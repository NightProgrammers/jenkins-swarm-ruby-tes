FROM wuhuizuo/ruby-tes:v0.9
MAINTAINER Wuhui Zuo <wuhuizuo@126.com>

### install openjdk-8-jre-headless
ENV JAVA_VERSION 8u141
ENV JAVA_DEBIAN_VERSION 8u141-b15-1~deb9u1
ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-8-jre-headless="$JAVA_DEBIAN_VERSION" \
        ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
        zip \
    && apt-get clean && apt-get autoclean \    
    && rm -rf /var/lib/apt/lists/*
# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure
###

### install jenkins-slave
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client.jar \
  http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.5/swarm-client-3.5.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/swarm-client.jar
###

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
ENV HOME /home/jenkins
RUN useradd -c "Jenkins user" -d $HOME -m jenkins

VOLUME /home/jenkins
WORKDIR /home/jenkins
USER root

ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/swarm-client.jar"]
