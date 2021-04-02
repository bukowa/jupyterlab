FROM jupyter/scipy-notebook@sha256:232ecb8da6abaa47ed41ef9c275ebced38245a1f35367f45b6d1b17e089bfb1e
RUN wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz &&\
    mkdir ~/bin &&\
    tar -C ~/bin -xzf go1.16.2.linux-amd64.tar.gz &&\
    rm go1.16.2.linux-amd64.tar.gz
ENV PATH=$PATH:~/bin/go/bin
RUN go version && mkdir $(go env GOPATH)

# go support v0.7.2
# https://github.com/gopherdata/gophernotes#linux-or-freebsd
RUN go get github.com/gopherdata/gophernotes@70b4546b2dc998d6ee7e898b659f47c96bde1bbd \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cd ~/.local/share/jupyter/kernels/gophernotes \
    && cp "$(go env GOPATH)"/pkg/mod/github.com/gopherdata/gophernotes@v0.7.2/kernel/*  "." \
    && chmod +w ./kernel.json # in case copied kernel.json has no write permission \
    && sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < kernel.json.in > kernel.json

ENV PATH=$PATH:$HOME/go/bin