ARG NODE_VERSION=14.16.1
FROM node:$NODE_VERSION as node

FROM ubuntu:20.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        cmake \
        curl \
        gpp \
        lmodern \
        libappindicator3-1 \
        libatspi2.0-0 \
        libasound2 \
        libgconf-2-4 \
        libgbm-dev \
        libgtk-3-0 \
        libnotify4 \
        libnss3 \
        libsecret-1-0 \
        libxss1 \
        libxtst6 \
        make \
        pandoc \
        sudo \
        texlive \
        texlive-extra-utils \
        texlive-latex-extra \
        texlive-pictures \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        wget \
        xdg-utils \
        xvfb

RUN mkdir -p /root/texmf/tex/latex
COPY docker/tikz-uml.sty /root/texmf/tex/latex/

RUN mkdir -p /usr/local/lib/node_modules/npm/bin
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && npm -v

RUN npm install -g markdownlint-cli

ARG DRAWIO_VERSION=14.5.1
ARG DRAWIO_REPO=https://github.com/jgraph/drawio-desktop/releases/download/
RUN wget --no-check-certificate ${DRAWIO_REPO}v$DRAWIO_VERSION/drawio-amd64-$DRAWIO_VERSION.deb -O /tmp/drawio.deb && \
    apt install /tmp/drawio.deb

COPY . /docmake-build
RUN mkdir /docmake-build/install_build && \
    cmake -S /docmake-build -B /docmake-build/install_build && \
    cmake --build /docmake-build/install_build --target install

COPY docker/entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

RUN useradd -m docmake
ENV DISPLAY ":99"
ENV CODE_DIR /docmake
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["default"]
