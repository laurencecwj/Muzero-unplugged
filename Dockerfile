# A Dockerfile that sets up a full Gym and Pytorch
# FROM python:3.9.16
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04
# FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

WORKDIR /app

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y \
    wget curl vim git build-essential \
    unzip \
    libglu1-mesa-dev \
    libgl1-mesa-dev \
    libosmesa6-dev \
    xvfb \
    patchelf swig \
    ffmpeg cmake \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

ENV PATH /root/.local/bin:/mypy/bin:${PATH}
RUN wget -qO- https://astral.sh/uv/install.sh | sh \
    && /root/.local/bin/uv python install 3.9 \
    && cd / && /root/.local/bin/uv venv --python 3.9 mypy \
    && . /mypy/bin/activate && uv pip install pip
     
RUN mkdir /root/.mujoco && cd /root/.mujoco \
    && wget -qO- 'https://github.com/deepmind/mujoco/releases/download/2.1.0/mujoco210-linux-x86_64.tar.gz' | tar -xzvf -

COPY req.txt /app
RUN pip install -r req.txt
COPY . /app
RUN pip install -e . 

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/root/.mujoco/bin"

EXPOSE 8888

ENTRYPOINT ["/mypy/bin/jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--notebook-dir=/app", "--NotebookApp.default_url=tutorial.ipynb,README.md","--NotebookApp.terminals_enabled=True"]