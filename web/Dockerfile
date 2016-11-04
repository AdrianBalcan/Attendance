FROM elixir:1.3-slim
MAINTAINER Adrian Balcan

ENV REFRESHED_AT 2016-10-10
ENV ELIXIR_VERSION 1.3.4
ENV HOME /root

RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.6.1

RUN apt-get update && apt-get install -y xz-utils wget inotify-tools
RUN wget "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"
RUN tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local
RUN ln -s "/usr/local/node-v$NODE_VERSION-linux-x64/bin/node" /usr/bin/node
RUN ln -s "/usr/local/node-v$NODE_VERSION-linux-x64/bin/npm" /usr/bin/npm
RUN mkdir /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
WORKDIR /app/attendance
EXPOSE 4000

#CMD ["sh", "-c", "ls"]
CMD ["sh", "-c", "mix deps.get && mix ecto.migrate && mix phoenix.server"]
#CMD ["mix phoenix.new attendance"]
