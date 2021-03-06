# Original copyright (c) Andres Vidal.
# Modified by: Tony Hirst
# Distributed under the terms of the MIT License.
FROM ouvocl/base-py38

LABEL created_by=https://github.com/andresvidal/jupyter-armv7l
#ARG wheelhouse=https://github.com/OpenComputingLab/jupyter-armv7l/raw/master

#We can pass variables into the build process via --build-arg variables
#We name them inside the Dockerfile using ARG, optionally setting a default value
#ARG RELEASE=3.1
ARG JUPYTER_TOKEN=letmein

#ENV vars are environment variables that get baked into the image
#We can pass an ARG value into a final image by assigning it to an ENV variable
ENV JUPYTER_TOKEN=$JUPYTER_TOKEN

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
RUN mkdir /notebooks

#RUN jupyter notebook --generate-config

# TO DO - need to sort out proper NB_USER
COPY .jupyter/ /root/.jupyter/
RUN echo "c.NotebookApp.token='$JUPYTER_TOKEN'" >> /root/.jupyter/jupyter_notebook_config.py

WORKDIR /notebooks
EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--ip=*", "--allow-root", "--no-browser", "--port=8888"]
