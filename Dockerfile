FROM rocker/r-base

ARG WHEN

CMD R -e "source('/R/requirements.R')"

CMD R -e "source('/R/GetFollowers.R')"
