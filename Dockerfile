FROM rocker/tidyverse as pandoc
RUN apt update && \
    apt install -y pandoc fonts-humor-sans

# RUN /rocker_scripts/install_pandoc.sh

FROM pandoc as other_dependencies
RUN apt update && \
    apt install -y libjpeg-dev \
    libpng-dev libssl-dev libxml2-dev libcairo2-dev libfontconfig1-dev vim libgdal-dev libudunits2-dev
RUN apt-get upgrade -y

# https://notes.rmhogervorst.nl/post/2020/09/23/solving-libxt-so-6-cannot-open-shared-object-in-grdevices-grsoftversion/
RUN apt-get install -y --no-install-recommends libxt6

RUN apt-get clean all && \
  apt-get purge && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

FROM other_dependencies as r_libs
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
RUN install2.r --error  languageserver
RUN R -e "hrbrthemes::import_roboto_condensed()" && \
  cp /usr/local/lib/R/site-library/hrbrthemes/fonts/roboto-condensed/*.ttf /usr/local/share/fonts/.

RUN mkdir projects
