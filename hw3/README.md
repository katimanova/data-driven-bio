# README

## Описание
Этот пайплайн предназначен для обработки данных SRA вирусов COVID (SRR31122807 и SRR31122808) с использованием Snakemake, обеспечивая воспроизводимость и изоляцию окружения с помощью Conda и Docker.

### Основные этапы обработки:
1. Проверка качества входных данных – *fastqc*
2. Сборка последовательностей – *spades*
3. Контроль качества собранных файлов – *quast*
4. Аннотация собранных последовательностей – *prokka*
5. Поиск генов устойчивости и вирулентности – *abricate*


## Требования
1. Установленный [Conda](https://docs.conda.io/en/latest/) или [Mamba](https://mamba.readthedocs.io/).
2. Установленный [Docker](https://www.docker.com/).
3. Поддержка Snakemake версии 8.

## Установка и подготовка к запуску
Следуйте этим шагам, чтобы подготовить среду перед запуском пайплайна:

### 1. Создание и активация окружения Snakemake
Используйте Mamba для создания окружения с Snakemake версии 8:

```bash
mamba create -n snakemake -c bioconda -c conda-forge snakemake=8
```

После завершения установки активируйте созданное окружение:

```bash
conda activate snakemake
```

### 2. Проверка версий
Убедитесь, что установлены нужные версии Snakemake и Docker.

#### Проверка версии Snakemake:
```bash
snakemake --version
```

Вы должны увидеть версию 8.x.x.

#### Проверка версии Docker:
```bash
docker --version
```

Убедитесь, что Docker установлен и запущен (у меня при запуске Docker version 27.2.0, build 3ab4256)

### 3. Запуск пайплайна
После активации окружения и проверки версий запустите пайплайн командой:

```bash
snakemake --use-conda
```

## Примечания
- Убедитесь, что Docker запущен перед выполнением команды Snakemake.