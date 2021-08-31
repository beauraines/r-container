FROM rocker/tidyverse as base

FROM base as pandoc
RUN apt update && \
    apt install -y pandoc fonts-humor-sans
RUN apt update && \
    apt install -y libjpeg-dev libpng-dev libssl-dev libxml2-dev libcairo2-dev libfontconfig1-dev vim libgdal-dev libudunits2-dev
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

FROM pandoc as r_libs
RUN install2.r --error  flexdashboard
RUN install2.r --error  zoo
RUN install2.r --error  RSocrata
RUN install2.r --error  hrbrthemes
RUN install2.r --error  plotly
RUN install2.r --error  emojifont
RUN install2.r --error  choroplethr
RUN install2.r --error  choroplethrMaps
RUN install2.r --error  AzureStor
RUN install2.r --error  geofacet
RUN R -e "hrbrthemes::import_roboto_condensed()" && \
  cp /usr/local/lib/R/site-library/hrbrthemes/fonts/roboto-condensed/*.ttf /usr/local/share/fonts/.
