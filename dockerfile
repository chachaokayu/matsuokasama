FROM jfrog.aisingroup.com/docker-local/ubuntu:focal-20221130

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update \
    && apt install -y software-properties-common curl wget build-essential

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y  python3.11 python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

COPY requirements_cpu_kari.txt /root/

RUN pip3 install jupyterlab
RUN pip3 install --upgrade tensorflow
RUN pip3 install --upgrade tensorboard
RUN pip3 install -r /root/requirements_cpu_kari.txt


ARG root_password="asn10-ten"
RUN echo root:$root_password | chpasswd
