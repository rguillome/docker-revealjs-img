#######################################################
##
## 	Dock me if U Can presentation container descriptor
##
##  @author rguillom
#######################################################
FROM node:6

## Set the initial reveal version
ARG REVEAL_VERSION
ENV REVEAL_VERS ${REVEAL_VERSION:-3.3.0}

## Install all required inner libs and apps
RUN apt-get update && apt-get install -y --no-install-recommends unzip

## Get the correct version of the reveal release : THIS NEEDS A WEB ACCESS
RUN wget https://github.com/hakimel/reveal.js/archive/${REVEAL_VERS}.zip
RUN unzip ${REVEAL_VERS}.zip

## Set the extracted reveal directory as the 
WORKDIR reveal.js-${REVEAL_VERS}

## Installation of the reveal project with the node package manager : Bower, grunt and so on...
RUN npm install


## Prepare a directory for the build phase : must be replaced by a volume content during the run
RUN mkdir -p /show/slides

## Copy the actual reveal index page to our presentation directory
COPY index.html /show/index.html
## Delete the reveal index page (will be replaced by the index page from the volume)
RUN rm index.html
## Create the symbolic links : inside the working dir which is the reveal one, insert the presentation content
RUN ln -s /prez/index.html index.html
RUN ln -s /prez/slides	slides

EXPOSE 8000

CMD [ "npm", "start" ]