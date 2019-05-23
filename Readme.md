The finance data for the explorative analysis challenge is provided through a postgres database running in a Docker container.

Additionally, there is also Docker container image available that contains a Jupyter Notebook which can be used to access the data for the challenge.

# Setup the Environment

## Install Docker 

You need to install Docker on your Computer. Please follow the official [documentation](https://docs.docker.com/install). In case you are interested in more details about Docker please have a look at the [Docker Overview](https://docs.docker.com/engine/docker-overview) (this is not needed for the challenge). 

## Cleanup Environment
In case you were running the environment before and want a clean start, you might might want to cleanup the environment (will also undo all changes your ever did to the environment).

```bash
docker stop explorative-analysis-db
docker rm explorative-analysis-db 

docker network rm dbnet
```

## Database Setup

Create a common network used for communication between the database Docker container and the Jupyter Notebook Docker container. 

```bash
docker network create -d bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 dbnet
```

Start the docker container that provides the database

```bash
docker run --name explorative-analysis-db --net=dbnet -p 5432:5432 -e POSTGRES_DB=bank_db -e POSTGRES_USER=bank_user -e POSTGRES_PASSWORD=bank_pw -d postgres
```
Get access to the files provided in this git repository by [downloading](https://github.com/markif/ExplorativeAnalysisChallenge_HS2019/archive/master.zip) or cloning it.

Import the data into the database (please do not forget to replace `path_to_the_sqlc_to_you_want_to_import` with the actual path where the `dbdump.sqlc` file is located you want to import - e.g. `$(pwd)` on Linux for your current folder). This step is only needed when you started from scratch (first time or after a cleanup). 

```bash
docker run -it --net=dbnet -v "path_to_the_sqlc_to_you_want_to_import":/dump --rm postgres /bin/bash
# restore the data - the password is bank_pw (see above)
pg_restore -h 192.168.0.1 -U bank_user -d bank_db --format=c /dump/dbdump.sqlc
# test if the data is available (SELECT should count 1056320 elements)
psql -h 192.168.0.1 -U bank_user -d bank_db
SELECT COUNT(*) FROM trans;
exit
exit
```

Start the docker container that runs a Jupyter Notebook which can be used to access the database (please do not forget to replace `path_to_your_jupyter_files` with the actual path where you want to store the files on your computer - e.g. `$(pwd)` on Linux for your current folder).

Please see the console output for the URL (with token) to use in your browser.
```bash
docker run --name datascience-notebook --net=dbnet -p 8888:8888 -v "path_to_your_jupyter_files":/home/jovyan/work -it --rm i4ds/datascience-notebook
```

Or start Jupyter Notebook with disabled authentication (not a recommended practice)
```bash
docker run --name datascience-notebook --net=dbnet -p 8888:8888 -v "path_to_your_jupyter_files":/home/jovyan/work -it --rm i4ds/datascience-notebook start-notebook.sh --NotebookApp.token=''
# open your browser on http://127.0.0.1:8888
firefox http://127.0.0.1:8888
```

Use the Jupyter Notebook Check_Data.ipynb to see if the database access works.


## Helpful Commands

Stop the database Docker container

```bash
docker stop explorative-analysis-db
```

Start the database Docker container (e.g. after a restart of your computer)

```bash
docker start explorative-analysis-db
```

Remove the database Docker container from your computer (this will undo all the changes you applied to the container)

```bash
docker stop explorative-analysis_db
docker rm explorative-analysis-db
```
