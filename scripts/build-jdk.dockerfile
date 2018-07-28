FROM alpine:latest
MAINTAINER  Manitha Silva

CMD apt-get update
CMD apt-get upgrade
CMD add-apt-repository ppa:webupd8team/java
CMD apt-get update
CMD echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
CMD apt-get install -y oracle-java8-installer
CMD apt install oracle-java8-set-default
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV JRE_HOME=/usr/lib/jvm/java-8-oracle/jre
CMD echo java -version
