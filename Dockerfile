FROM node:0.10-onbuild

MAINTAINER Roy van de Water <roy.v.water@gmail.com>

EXPOSE 3004
ENV PATH $PATH:/usr/local/bin
ENV NODE_ENV production

ADD . rdio-sync-api

WORKDIR rdio-sync-api
RUN npm --no-color --force --production install

CMD ["npm", "start"]
