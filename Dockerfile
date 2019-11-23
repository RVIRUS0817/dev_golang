FROM alpine
 
# basic install 
RUN apk update
RUN apk add --no-cache wget bash git supervisor gcc build-base
 
# install glibc
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
RUN apk add glibc-2.28-r0.apk
RUN rm /etc/apk/keys/sgerrand.rsa.pub glibc-2.28-r0.apk
 
# go 1.11.1 install,delete gz
RUN wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz --no-check-certificate -P /tmp
RUN tar -C /usr/local -xzf /tmp/go1.11.1.linux-amd64.tar.gz \
    && rm /tmp/go1.11.1.linux-amd64.tar.gz
 
# settimg go path
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
 
# install nginx
RUN apk add nginx
RUN mkdir -p /run/nginx
 
# copy adachin.conf
WORKDIR /etc/nginx/conf.d/
COPY ./nginx/adachin.conf adachin.conf
 
# build directories
RUN mkdir -p /go/src/github.com/adachin-go
WORKDIR /go/src/github.com/adachin-go
 
# go get 
RUN go get -u github.com/pressly/goose/cmd/goose \
    github.com/lestrrat-go/test-mysqld \
    github.com/volatiletech/sqlboiler \
    github.com/volatiletech/sqlboiler/drivers/sqlboiler-mysql \
    github.com/golang/dep/cmd/dep \
    github.com/tockins/realize
 
# copy service.sh
COPY service.sh /root/service.sh
 
# clean apk cache
RUN rm -rf /var/cache/apk/*
