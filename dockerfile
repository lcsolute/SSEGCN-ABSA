FROM dabinjeong/cuda:10.1-cudnn7-devel-ubuntu18.04

# 安装 Python3.7 和基础依赖
RUN apt-get update && apt-get install -y \
    python3.7 python3.7-dev python3.7-distutils python3-pip \
    build-essential wget unzip git \
    ca-certificates libglib2.0-0 libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 升级 pip
RUN python3.7 -m pip install --upgrade pip

# 复制 Python 依赖文件并安装
COPY requirements.txt /tmp/
RUN python3.7 -m pip install --no-cache-dir -r /tmp/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制项目代码
COPY . /workspace/SSEGCN
WORKDIR /workspace/SSEGCN

# 创建 GloVe 目录并下载解压向量
RUN mkdir -p /workspace/SSEGCN/glove && \
    wget -c -O /workspace/SSEGCN/glove/glove.840B.300d.zip https://nlp.stanford.edu/data/glove.840B.300d.zip && \
    unzip /workspace/SSEGCN/glove/glove.840B.300d.zip -d /workspace/SSEGCN/glove && \
    ln -s /usr/bin/python3.7 /usr/bin/python
# ENTRYPOINT 或 CMD 仅进入 bash
CMD ["bash"]
