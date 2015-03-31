FROM node:0.10-onbuild

EXPOSE 3004

ENV PATH $PATH:/usr/local/bin

MAINTAINER Roy van de Water <roy.v.water@gmail.com>

RUN git clone --depth=1 https://github.com/royvandewater/rdio-sync-api

WORKDIR rdio-sync-api
RUN npm --no-color install

CMD ["npm", "start"]
