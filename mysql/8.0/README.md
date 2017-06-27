# lazy-docker - mysql8.0

> Easily and quickly create mysql8.0 docker containers at the terminal.

## Feature

- [x] [Run](#runsh)
- [x] [Backup](#backupsh)
- [x] [Restore](#restoresh)

## Usage

First, make sure you have [Docker](https://docs.docker.com/) installed.

### Persistence

> NOTE: If you do not plan to implement long-term deployment through configuration files,
Please _skip_ this section.

1. Edit the [.env](https://github.com/WindomZ/lazy-docker/blob/master/mysql/8.0/.env) file with your familiar text editor.
1. Please fill in your configuration information according to the notes.

### Execute

Please open your terminal.

#### **run.sh**

> Interactive design, quickly to deploy MySQL container.

Run the following command at the terminal to deploy MySQL container: 
```bash
./run.sh
```

#### **backup.sh**

> Quickly backup MySQL container data.

Run the following command at the terminal to backup MySQL data: 
```bash
./backup.sh
```

#### **restore.sh**

> Quickly restore MySQL container data from backup file.

Run the following command at the terminal to restore MySQL data: 
```bash
./restore.sh FILE
```
The `FILE` see `backup.sh` result.

## Official

- [DockerHub](https://hub.docker.com/_/mysql/)
- [GitHub](https://github.com/docker-library/mysql/tree/master/8.0)

[<< GoBack](https://github.com/WindomZ/lazy-docker#readme)
