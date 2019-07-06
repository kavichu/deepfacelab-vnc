FROM nvidia/cuda:9.0-base-ubuntu16.04 as deepfakelab
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-9-0 \
        cuda-cufft-9-0 \
        cuda-curand-9-0 \
        cuda-cusolver-9-0 \
        cuda-cusparse-9-0 \
        libcudnn7=7.2.1.38-1+cuda9.0 \
        libnccl2=2.2.13-1+cuda9.0 \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0 && \
        apt-get update && \
        apt-get install libnvinfer4=4.1.2-1+cuda9.0

RUN apt-get update && apt-get install -y \
    cmake \
    git \
    python3 \
    python3-pip \
    libsm6 \
    libxext6 \
    libxrender-dev

# RUN pip3 install --upgrade \
#     pip \
#     setuptools

#RUN pip3 install -r requirements-cuda.txt

FROM deepfakelab

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

RUN git clone https://github.com/lbfs/DeepFaceLab_Linux.git /workspace/DeepFaceLab_Linux

WORKDIR /workspace/DeepFaceLab_Linux
ENV HOME=/workspace/DeepFaceLab_Linux \
    SHELL=/bin/bash

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean \
    && apt-get install -y --no-install-recommends software-properties-common curl
RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
        openssh-server pwgen sudo vim-tiny \
        supervisor \
        net-tools \
        lxde x11vnc xvfb autocutsel \
        xfonts-base lwm xterm \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        dbus-x11 x11-utils \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image/etc /etc
ADD image/root /root
ADD image/usr/share /usr/share
ADD image/startup.sh /startup.sh

WORKDIR /usr/src/app

RUN git clone https://github.com/novnc/noVNC.git /usr/lib/noVNC && \
    git clone https://github.com/kanaka/websockify /usr/src/app/noVNC/websockify

EXPOSE 80
WORKDIR /workspace/DeepFaceLab_Linux
ENV HOME=/workspace/DeepFaceLab_Linux \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
CMD ["/bin/bash"]
