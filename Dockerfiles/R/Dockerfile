FROM tensorflow/tensorflow:1.13.1-py3
#FROM tensorflow/tensorflow:1.13.1-gpu-py3 # para versao com gpu

#Todas as versoes do Tensorflow sao baseadas no Ubuntu 16.04 (Xenial) - ajustar configuracoes de acordo

LABEL maintainer="Elias Youssef - https://github.com/nettoyoussef/science-reproducibility"


#Baseado nos trabalhos de:
#   Jim Thompson - https://github.com/jimthompson5802/mlflow_demo/blob/master/run_demo/docker-compose.yml
#   pbhogale - https://github.com/pbhogale/gpu-keras-rstudio
#   Kai Lichtenberg <kai@sentin.ai>" https://klichtenberg.com/?p=151
#   Rocker/Rstudio - https://hub.docker.com/r/rocker/rstudio/dockerfile 
#   Rocker/ML - https://hub.docker.com/r/rocker/ml/dockerfile
#   joelnitta - https://github.com/joelnitta/docker-packrat-example
#   ecohealth - https://github.com/ecohealthalliance/reservoir
#   anurag - https://github.com/anurag/fastai-course-1
#   https://ildiczeller.com/2017/09/17/r-pkg-check-with-docker-on-codeship/
#   Rstudio-builds - https://github.com/rstudio/r-docker/blob/master/base/bionic/Dockerfile 

## Shell tools
RUN apt-get update && apt-get install -y --force-yes --allow-unauthenticated --no-install-recommends --no-upgrade \      
    apt-utils                           \
    apt-transport-https                 \    
    build-essential                     \
    cmake                               \
    coinor-libsymphony-dev              \
    coinor-libcgl-dev                   \
    curl                                \
    ed                                  \
    fonts-texgyre                       \
    git                                 \
    gcc                                 \
    gdebi-core                          \
    gedit                               \
    gzip                                \
    gnupg                               \
    gnupg2                              \
    gfortran                            \
    libapparmor1                        \
    libatlas-base-dev                   \
    libbz2-dev                          \
    libcairo2                           \
    libcurl4-openssl-dev                \
    libgdal-dev                         \
    libgeos-dev                         \
    libglpk-dev                         \
    libicu-dev                          \
    liblzma-dev                         \
    libncurses5-dev                     \
    libopenblas-base                    \
    libopenmpi-dev                      \
    libpango-1.0-0                      \
    libpangocairo-1.0-0                 \
    libpcre3-dev                        \
    libpq-dev                           \      
    libproj-dev                         \    
    libssl-dev                          \
    libssh2-1-dev                       \
    libtcl8.6                           \
    libtiff5                            \
    libtk8.6                            \
    libx11-6                            \
    libxml2-dev                         \
    libxt6                              \
    locales                             \
    pandoc                              \         
    pandoc-citeproc                     \ 
    qpdf                                \ 
    sudo                                \
    tzdata                              \
    vim-tiny                            \
    virtualenv                          \
    wget                                \
    zlib1g-dev                          \
    python-pip python-setuptools python-dev build-essential
    

################################

# Setting user

################################

#Set a user 
ARG USER
ARG PASSWORD
ENV USERID=1000
ARG UID="1000"
ARG GID="1000"
 
RUN echo "User: $USER"
RUN echo "Password: $PASSWORD" 
 
RUN echo "creating new $USER with UID $USERID"

RUN groupadd --gid "${GID}" "${USER}" \
  && useradd \
  -u $USERID \
    --uid ${UID} \
    --gid ${GID} \
    --create-home \    
    --shell /bin/bash \
${USER}

RUN mkdir -p /home/$USER \
&&  usermod -a -G staff $USER\
## Add a password to user
&& echo "$USER:$PASSWORD" | chpasswd \
&&  chown -R $USER:$USER /home/$USER \
&& addgroup $USER staff


###############################################################

# R installation

###############################################################

# escolhe versao do R a ser instalada para sua versao do Ubuntu 
ENV R_BASE_VERSION 3.6.1
          
# Adiciona mirror 
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/" >> /etc/apt/sources.list \
  && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | sudo apt-key add -
  
#Fonte:
#https://cloud.r-project.org/bin/linux/ubuntu/README.html



# Install R-base (rocker/r-base with little modification)
# Also set a default CRAN repo, and make sure littler knows about it too

## Now install R and littler, and create a link for littler in /usr/local/bin
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    littler \
    r-cran-littler \
    r-base=${R_BASE_VERSION}-*\
  && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
  && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
  && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
  && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
  && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
  && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
  && install.r docopt \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && rm -rf /var/lib/apt/lists/*          
  
# Install tensorflow and keras inside R
#ENV WORKON_HOME=/home/${USER}/.virtualenvs
 
#RUN install2.r devtools remotes \
#  && installGithub.r rstudio/tensorflow \
#  && installGithub.r rstudio/keras \
#  && virtualenv --system-site-packages /home/${USER}/.virtualenvs/r-tensorflow --python=python3.5 \
#  && /bin/bash -c "cd /home/${USER}/.virtualenvs/r-tensorflow/bin/; \
#     source activate;" 


###############################################################

# JAVA installation

###############################################################

# Install JAVA
RUN apt-get update -qq \
&& apt-get -y --no-install-recommends install \
   default-jdk \
   default-jre \
&& R CMD javareconf    

   
###############################################################

# Python installation

###############################################################

# install miniconda and prereq libraries - para usar Mlflow
RUN echo "Installing Miniconda"    
RUN apt-get update && \
    apt-get install -y zlib1g-dev libxml2-dev bzip2 && \
    wget -nv https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
      -O /tmp/miniconda.sh  && \
    bash /tmp/miniconda.sh -b -p /opt/conda

# Instala pacotes Python
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt 

# set up path to conda binary
ENV PATH /opt/conda/bin:$PATH

   
####################################   
   
# R packages

####################################

# Renv lockfile - versao de bibliotecas para instalar
COPY ./renv.lock /home/renv/renv.lock
COPY ./renv_0.6.0-28.tar.gz /home/renv/renv_0.6.0-28.tar.gz

RUN R -e 'setwd("/home/renv/"); renv <- list.files( pattern = "^renv_"); print(renv); install.packages(renv, repos = NULL, type = "source"); library(renv); renv::restore(project = "/home/renv/", lockfile = "/home/renv/renv.lock");'

# Modify Rprofile.site so R loads packrat library by default
RUN echo '.libPaths(c("/home/eliasy/R/x86_64-pc-linux-gnu-library/3.6/", "/home/renv/renv/library/R-3.6/x86_64-pc-linux-gnu/", .libPaths()))' >> etc/R/Rprofile.site


###############################################################

# Rstudio IDE installation

###############################################################


#Instala Rstudio
RUN wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb  \
    && gdebi --option=APT::Get::force-yes=1,APT::Get::Assume-Yes=1 -n  rstudio-server-1.2.1335-amd64.deb    

 
EXPOSE 8787

CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]   











