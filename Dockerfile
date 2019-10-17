FROM rocker/r-base

CMD R -e "source('/R/requirements.R')"

CMD R -e "source('/R/GetFollowers.R')"
