#FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04
FROM nvidia/cudagl:9.0-devel-ubuntu16.04

RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop

RUN apt-get install -y libnspr4 libnss3 libpango1.0-0  xdg-utils libpq5 npm
RUN curl http://beta.unity3d.com/download/ad31c9083c46/unity-editor_amd64-2017.2.0f1.deb --output unity-editor_amd64-2017.2.0f1.deb
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash 
RUN apt-get install git-lfs && sudo git lfs install

#Install packages for PyTorch
#RUN apt-get update && \
#    apt-get install --no-install-recommends -y autoconf binutils-doc bison \
#    build-essential flex gettext ncurses-dev automake asciidoc curl wget \
#    libopenblas-dev libopenmpi-dev lsb-release xsltproc docbook-xsl docbook-xml \
#    gfortran ccache ca-certificates openjdk-8-jdk git g++-multilib && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install conda py3
RUN curl https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh \
    -o ~/miniconda.sh &&  #\
#    bash ~/miniconda.sh -b -p ~/miniconda && \
#    export PATH=~/miniconda/bin:$PATH && \
#    conda install -y pyyaml cmake && \
#    pip install numpy && \
#    conda clean -ya


# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443

# Fix VirtualGL for sudo
RUN chmod u+s /usr/lib/libdlfaker.so /usr/lib/libvglfaker.so

# Metadata
ADD ./NAE/nvidia.cfg /etc/NAE/nvidia.cfg
COPY NAE/AppDef.json.8.0-cudnn7-devel-ubuntu16.04 /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate
