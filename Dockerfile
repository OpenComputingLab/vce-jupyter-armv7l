# Copyright (c) Andres Vidal.
# Distributed under the terms of the MIT License.
FROM python:3.8

LABEL created_by=https://github.com/andresvidal/jupyter-armv7l
#ARG wheelhouse=https://github.com/OpenComputingLab/jupyter-armv7l/raw/master

# Install all OS dependencies for fully functional notebook server
# https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    tzdata \
    unzip \
    nano \
    wget \
    bzip2 \
    ca-certificates \
    locales \
    libblas-dev \
    liblapack-dev \
    gfortran \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

COPY ./wheelhouse/ ./wheelhouse/
RUN echo kiwisolver matplotlib numpy scipy pandas pyzmq | xargs -n 1 pip install --find-links=./wheelhouse && rm -r ./wheelhouse

RUN pip install --upgrade jupyter

RUN jupyter notebook --generate-config

COPY .jupyter/ .jupyter/
WORKDIR /notebooks
EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--ip=*", "--allow-root", "--no-browser", "--port=8888"]
