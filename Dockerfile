FROM ubuntu:22.04
LABEL maintainer="Aurelie Albert <aurelie.albert@univ-grenoble-alpes.fr>"
LABEL version="0.1"

#Add a sudo user so that packages can be installed
RUN apt-get update && \
      apt-get -y install sudo

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

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

# Add nextsimdg exe to path
ENV PATH="/tmp/nextsimdg/build/bin:$PATH"

# Install conda
RUN wget --quiet --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    sudo /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

CMD [ "/bin/bash" ]    
