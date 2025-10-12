# Dockerfile: Ubuntu 20.04 + Miniconda + PyTorch + CI/CD + interactive
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# -----------------------------
# 1) 基础依赖
# -----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    build-essential \
    wget \
    curl \
    git \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# -----------------------------
# 2) 安装 Miniconda
# -----------------------------
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    && rm /tmp/miniconda.sh \
    && $CONDA_DIR/bin/conda clean -afy

ENV PATH=$CONDA_DIR/bin:$PATH

# -----------------------------
# 3) 创建 Conda 环境 Python 3.11
# -----------------------------
RUN conda create -y -n py311 python=3.11 \
    && conda clean -afy

SHELL ["conda", "run", "-n", "py311", "/bin/bash", "-c"]

# -----------------------------
# 4) 安装 PyTorch CPU 版本
# -----------------------------
# RUN pip install --no-cache-dir \
#     torch==2.8.1+cpu \
#     torchvision==0.15.2+cpu \
#     torchaudio==2.0.2+cpu \
#     --index-url https://download.pytorch.org/whl/cpu

# GPU 版本可在 pipeline 中替换对应 CUDA wheel
RUN pip install --no-cache-dir torch==2.8.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2+cu118 --index-url https://download.pytorch.org/whl/cu118

# -----------------------------
# 5) 安装常用工具
# -----------------------------
RUN pip install --no-cache-dir numpy scipy pandas matplotlib jupyterlab flake8 pytest

# -----------------------------
# 6) 拷贝外部 entrypoint 脚本
# -----------------------------
COPY entrypoint.py /workspace/entrypoint.py

# -----------------------------
# 7) 默认 CI/CD 脚本 & 交互模式
# -----------------------------
ENV CI_SCRIPT=/workspace/test_gpu.py
ENV INTERACTIVE=0

# -----------------------------
# 8) 默认 CMD：执行 entrypoint
# -----------------------------
CMD ["python", "/workspace/entrypoint.py"]
