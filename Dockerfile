FROM jupyter/minimal-notebook

USER root

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
	software-properties-common \
	gdebi-core \
	libapparmor1 \
	dirmngr \
	gpg-agent \
	strace \
	lsof \
	less

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository -y 'deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/'

RUN apt-get update -qq -y && \
    apt install -y r-base r-base-core r-recommended

#ENV RSTUDIO_VERSION 2024.12.1-563
ENV RSTUDIO_VERSION 2024.12.1-563

RUN wget --quiet https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    gdebi -n rstudio-server-${RSTUDIO_VERSION}-amd64.deb && \
    rm rstudio-server-${RSTUDIO_VERSION}-amd64.deb

USER $NB_USER
RUN pip install jupyter-rsession-proxy
RUN pip install jupyter-server-proxy

USER root

USER jovyan
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"
