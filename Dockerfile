FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-runtime

WORKDIR /workdir

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    gcc
RUN pip install \
    numpy \
    torchvision==0.4.1 \
    'git+https://github.com/facebookresearch/fvcore' \
    simplejson \
    sklearn \
    pandas 
RUN conda install av -c conda-forge

COPY ./slowfast /packages/slowfast
ENV PYTHONPATH=$PYTHONPATH:/packages/slowfast

RUN pip install -U torch torchvision cython
RUN pip install -U 'git+https://github.com/facebookresearch/fvcore.git' 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'
RUN git clone https://github.com/facebookresearch/detectron2 /packages/detectron2
RUN pip install -e /packages/detectron2
# You can find more details at https://github.com/facebookresearch/detectron2/blob/master/INSTALL.md

COPY . /workdir/SlowFast
RUN cd /workdir/SlowFast &&\
    python setup.py build develop

# configure ipython
RUN pip install jupyterlab pytorch_lightning
COPY ipython_config.py /root/.ipython/profile_default/ipython_config.py
# configure jupyter
COPY jupyter_notebook_config.py /root/.jupyter/

###############################
## SETUP ENVIRONMENT
###############################
ENV ROOT_DIR=/workdir
ENV PASSWORD=tf

CMD ["bash"]
