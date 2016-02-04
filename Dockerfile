FROM alpine:3.3

ENV OPENRESTY_VERSION 1.9.7.3
ENV OPENRESTY_PREFIX /opt/openresty
ENV OPENRESTY_BUILD_DEPS "make gcc musl-dev pcre-dev openssl-dev zlib-dev ncurses-dev readline-dev curl perl"
ENV OPENRESTY_DEPS "libpcrecpp libpcre16 libpcre32 openssl libssl1.0 pcre libgcc libstdc++"

RUN apk update \
  && apk add --virtual tmp-build-deps $OPENRESTY_BUILD_DEPS \
  && cd /tmp \
  && curl -sSL http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xvz \
  && cd openresty-${OPENRESTY_VERSION} \
  && ./configure \
       --prefix=$OPENRESTY_PREFIX \
       --with-luajit \
       --with-pcre-jit \
       --with-ipv6 \
       --with-http_ssl_module \
       --without-http_ssi_module \
       --without-http_userid_module \
       --without-http_uwsgi_module \
       --without-http_scgi_module \
  && make \
  && make install \
  && ln -s $OPENRESTY_PREFIX/nginx/sbin/nginx /usr/local/bin/nginx \
  && apk del tmp-build-deps \
  && apk add $OPENRESTY_DEPS \
  && rm -rf /tmp/openresty-*

WORKDIR $OPENRESTY_PREFIX/nginx
CMD ["nginx", "-g", "daemon off;"]
