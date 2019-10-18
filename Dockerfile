FROM rocker/r-base

RUN mkdir -p /getFollowers/data/followers
RUN mkdir -p /getFollowers/R


COPY /R/get_followers.R /getFollowers/R/get_followers.R
COPY /R/get_followers_total.R /getFollowers/R/get_followers_total.R
COPY /R/headers_handler.R /getFollowers/R/headers_handler.R
COPY /R/utils.R /getFollowers/R/utils.R
COPY /R/requirements.R /getFollowers/R/requirements.R
COPY /R/GetFollowers.R /getFollowers/R/GetFollowers.R

COPY /data/export_h.csv /getFollowers/data/export_h.csv
COPY /data/fake_users.csv /getFollowers/data/fake_users.csv
COPY /data/profiles.csv /getFollowers/data/profiles.csv

RUN apt-get update -y && \
      apt-get -y install sudo
Run sudo apt-get install -y r-base-core libxml2-dev libssl-dev libcurl4-openssl-dev &&\
      sudo apt-get install -y libcurl4-gnutls-dev libcurl4-gnutls-dev

CMD R -e "source('/getFollowers/R/GetFollowers.R')"


