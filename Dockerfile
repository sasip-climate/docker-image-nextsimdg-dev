FROM jupyter/docker-stacks-foundation
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add access to summer space
USER root

# Install all the necessary librairies for nextsimdg along with some tools 
RUN sudo apt-get update 
RUN sudo apt-get install vim git build-essential bash-completion wget netcdf-bin libnetcdf-c++4-dev libboost-all-dev libeigen3-dev cmake --assume-yes

# Get and install Catch2 from source
WORKDIR /tmp
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git
WORKDIR Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF 
RUN sudo cmake --build build/ --target install

# Get nextsimdg source from the dedicated branch for test case
WORKDIR /tmp
RUN git clone -b issue194_topaz_era https://github.com/nextsimdg/nextsimdg.git
WORKDIR nextsimdg

# Compile nextsimdg
RUN mkdir -p build
WORKDIR build
RUN cmake .. 
RUN make

WORKDIR /tmp

# Install jupyter environment (taken from https://github.com/jupyter/docker-stacks/blob/main/base-notebook/Dockerfile)

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-liberation \
    # - pandoc is used to convert notebooks to html files
    #   it's not present in aarch64 ubuntu image, so we install it here
    pandoc \
    # - run-one - a wrapper script that runs no more
    #   than one unique  instance  of  some  command with a unique set of arguments,
    #   we use `run-one-constantly` to support `RESTARTABLE` option
    run-one && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
RUN mamba install --yes \
    'notebook' \
    'jupyterhub' \
    'jupyterlab' && \
    jupyter notebook --generate-config && \
    mamba clean --all -f -y && \
    npm cache clean --force && \
    jupyter lab clean 

ENV JUPYTER_PORT=8888
EXPOSE $JUPYTER_PORT
# Configure container startup
CMD ["start-notebook.sh"]

# Copy local files as late as possible to avoid cache busting
COPY start-notebook.sh start-singleuser.sh /usr/local/bin/
# Currently need to have both jupyter_notebook_config and jupyter_server_config to support classic and lab
COPY jupyter_server_config.py docker_healthcheck.py /etc/jupyter/

# Fix permissions on /etc/jupyter as root
USER root

# Legacy for Jupyter Notebook Server, see: [#1205](https://github.com/jupyter/docker-stacks/issues/1205)
RUN sed -re "s/c.ServerApp/c.NotebookApp/g" \
    /etc/jupyter/jupyter_server_config.py > /etc/jupyter/jupyter_notebook_config.py && \
    fix-permissions /etc/jupyter/

# HEALTHCHECK documentation: https://docs.docker.com/engine/reference/builder/#healthcheck
# This healtcheck works well for `lab`, `notebook`, `nbclassic`, `server` and `retro` jupyter commands
# https://github.com/jupyter/docker-stacks/issues/915#issuecomment-1068528799
HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=3 \
    CMD /etc/jupyter/docker_healthcheck.py || exit 1
    
# Switch off jupyter newsletter prompt
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

WORKDIR "${HOME}"
