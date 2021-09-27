FROM ubuntu:20.04

RUN apt-get update
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates libgmp3-dev locales make m4 opam vim

RUN adduser --disabled-password --gecos "" ail
RUN locale-gen en_US.UTF-8 &&\
    echo "export LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8" >> /home/ail/.bashrc

USER ail
ENV WDIR /home/ail
WORKDIR ${WDIR}

RUN opam init -y --disable-sandboxing
RUN opam install -y ocamlbuild ocamlfind menhir zarith

ADD . ${WDIR}
USER root
RUN chmod 755 /home/ail
RUN chown -R ail:ail *
USER ail

RUN eval `opam config env`; make -C src

USER root
RUN echo 'su - ail' >> /root/.bashrc
