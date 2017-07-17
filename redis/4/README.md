# lazy-docker - redis4

> Easily and quickly create redis4 docker containers at the terminal.

## Feature

- [x] [Run](#runsh)
- [x] [Backup](#backupsh)
- [x] [Restore](#restoresh)

## Usage

First, make sure you have [Docker](https://docs.docker.com/) installed.

### Execute

Please open your terminal.

#### **run.sh**

> Interactive design, quickly to deploy Redis container.

Run the following command at the terminal to deploy Redis container: 
```bash
./run.sh
```

#### **backup.sh**

> Quickly backup Redis container data.

Run the following command at the terminal to backup Redis data: 
```bash
./backup.sh
```

#### **restore.sh**

> Quickly restore Redis container data from backup file.

Run the following command at the terminal to restore Redis data: 
```bash
./restore.sh FILE
```
The `FILE` see `backup.sh` result.

### Persistence

> NOTE: If you do not plan to implement long-term deployment through configuration files,
Please _skip_ this section.

1. Edit the [.env](https://github.com/WindomZ/lazy-docker/blob/master/redis/4/.env) file with your familiar text editor.
1. Please fill in your configuration information according to the notes.

## Official

- [DockerHub](https://hub.docker.com/_/redis/)
- [GitHub](https://github.com/docker-library/redis/tree/master/4.0)

[<< GoBack](https://github.com/WindomZ/lazy-docker#readme)
