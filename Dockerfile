FROM node:12

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install
#RUN npm ci --only=production

COPY bin/nodejs/b2b-api-service.js .

EXPOSE 8080

CMD ["node", "b2b-api-service.js"]
