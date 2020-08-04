FROM rocker/r-parallel

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  gcc-9-base \
  libgcc-9-dev \
  libc6-dev \
  libcurl4-openssl-dev \ 
  libssl-dev

# install R packages
RUN install.r \
  microbenchmark \ 
  promises \
  DBI \
  RPresto \
  future \
  glue \
  readr \
  listenv \
  lubridate \ 
  remotes

# install development version of plumber
RUN R -e "remotes::install_github('rstudio/plumber')"

# copy files over and start API
COPY /async-api /
WORKDIR /
EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]
CMD ["plumber.R"]