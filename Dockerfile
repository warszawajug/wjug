FROM dockerfile/nodejs

WORKDIR /source

RUN npm install marked --save

EXPOSE 3333

