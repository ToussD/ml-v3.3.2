docker container run -it -p 8888:8888 --rm --name cours-ml \
    --user root \
    -e GRANT_SUDO=yes \
    -e NB_UID=$(id -u) \
    -e NB_GID=$(id -g) \
    --mount type=bind,source=$(pwd)/work,target=/home/jovyan/work \
    daniel3350/jupyter-cours-ml:v1.0.1 \
    start-notebook.sh --NotebookApp.token='' --NotebookApp.password=''
