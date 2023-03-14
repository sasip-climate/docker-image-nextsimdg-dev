FROM ubuntu:22.04
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    imagemagick \
    git \
    lftp \
    nco \
    rsync \
    ssh \
    wget \
    apt-transport-https ca-certificates -y && \
    update-ca-certificates && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*

RUN wget --quiet --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH="/opt/conda/bin/:$PATH"

ADD environment.yml environment.yml
RUN conda env update --file environment.yml --name base && \
    /opt/conda/bin/conda clean -a && \
    rm -rf $HOME/.cache/yarn && \
    rm -rf /opt/conda/pkgs/*

RUN sudo apt-get update \
    sudo apt-get install netcdf-bin libnetcdf-c++4-dev libboost-all-dev libeigen3-dev cmake

WORKDIR /tmp
RUN git clone -b v2.x https://github.com/catchorg/Catch2.git
WORKDIR Catch2
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF \
    sudo cmake --build build/ --target install

WORKDIR /tmp
RUN git clone -b issue194_topaz_era https://github.com/nextsimdg/nextsimdg.git
WORKDIR nextsimdg
RUN cmake . \
    make
    
CMD [ "/bin/bash" ]    
