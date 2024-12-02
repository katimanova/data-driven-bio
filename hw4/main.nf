#!/usr/bin/env nextflow

// Чтение из CSV-файла
samples_channel = Channel
    .fromPath(params.samples_csv)
    .splitCsv(header: true)
    .map { row -> 
        tuple(
            row.sample_id, 
            file(row.read_1), 
            file(row.read_2), 
            row.assembly ? file(row.assembly) : '/null'
        )
    }

// Каналы со сборкой и без сборки
with_assembly = samples_channel.filter { sample_id, read_1, read_2, assembly -> assembly != '/null' && assembly.exists() }
without_assembly = samples_channel.filter { sample_id, read_1, read_2, assembly -> assembly == '/null' || !assembly.exists() }

println "SPAdes memory: ${params.spades.memory} MB"
println "SPAdes threads: ${params.spades.threads}"
println "FastQC threads: ${params.fastqc.threads}"
println "QUAST threads: ${params.quast.threads}"

process FastQC {
    tag "FASTQC on $sample_id"

    publishDir "./", mode: 'copy'

    input:
    tuple val(sample_id), path(read_1), path(read_2), path(assembly)

    output:
    tuple val(sample_id), path(read_1), path(read_2), path("test_output/fastqc/${sample_id}/*")

    script:
    """
    mkdir -p ./test_output/fastqc/${sample_id}/
    fastqc ${read_1} ${read_2} -o test_output/fastqc/${sample_id}/
    """
}

// Процесс SPAdes (только для образцов без сборки)
process SPAdes {
    tag "SPAdes on $sample_id"

    publishDir "./", mode: 'copy'

    input:
    tuple val(sample_id), path(read_1), path(read_2)

    output:
    tuple val(sample_id), path("test_output/spades/${sample_id}/scaffolds.fasta")

    script:
    """
    mkdir -p ./test_output/spades/${sample_id}/
    spades.py -1 ${read_1} -2 ${read_2} -o test_output/spades/${sample_id}/
    """
}

// Процесс QUAST
process QUAST {
    tag "QUAST on $sample_id"

    publishDir "./", mode: 'copy'

    input:
    tuple val(sample_id), path(assembly)

    output:
    path("test_output/quast/${sample_id}/report.txt")

    script:
    """
    mkdir -p ./test_output/quast/${sample_id}/
    quast.py -o ./test_output/quast/${sample_id} ${assembly}
    """
}

// Процесс Prokka
process Prokka {
    tag "Prokka on $sample_id"

    publishDir "./", mode: 'copy'

    input:
    tuple val(sample_id), path(assembly)

    output:
    tuple val(sample_id), path("test_output/prokka/${sample_id}/${sample_id}.gbk")

    script:
    """
    mkdir -p ./test_output/prokka/${sample_id}/
    prokka --force -o ./test_output/prokka/${sample_id} --prefix ${sample_id} ${assembly} --genus '${params.prokka.genus}'
    """
}

// Процесс Abricate
process Abricate {
    tag "Abricate on $sample_id"

    publishDir "./", mode: 'copy'

    input:
    tuple val(sample_id), path(annotation)

    output:
    path("test_output/abricate/${sample_id}_abricate_results.txt")

    script:
    """
    mkdir -p ./test_output/abricate/
    abricate --db ${params.abricate.databases} ${annotation} > test_output/abricate/${sample_id}_abricate_results.txt
    """
}

// Основной workflow
workflow {
    // Подготовка канала для сборки
    channel_for_assembly = without_assembly
        | FastQC
        | map { sample_id, read_1, read_2, fastqc_output -> 
            tuple(sample_id, read_1, read_2) // Передаем только нужные элементы
        }
        | SPAdes
        | map { sample_id, scaffolds -> 
            tuple(sample_id, file("test_output/spades/${sample_id}/scaffolds.fasta")) // Убедимся, что scaffolds — это path
        }

    // Объединение сборок со сборками из входных данных
    unified_assembly = channel_for_assembly
        .mix(with_assembly.map { sample_id, read_1, read_2, assembly ->
            tuple(sample_id, file(assembly.toString())) // Преобразуем assembly в path
        })

    // QUAST для всех сборок
    unified_assembly
        | QUAST

    // Prokka для всех сборок
    annotations = unified_assembly
        | Prokka

    // Abricate для всех аннотаций
    annotations
        | Abricate
}
