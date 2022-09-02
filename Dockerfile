FROM registry.access.redhat.com/ubi8/ubi:latest
MAINTAINER Osvaldo Melo <omelo@redhat.com>

# update OS
RUN yum -y update && \
yum -y install sudo openssh-clients unzip java-11-openjdk-devel && \
yum clean all
# create directories
RUN mkdir -p /opt/ldap
RUN mkdir -p /opt/ldap/ldif

#set env to ldif files
ENV LDIF_FILE="ldif/example.ldif" \
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk" \
    JAVA_VENDOR="openjdk" \
    JAVA_VERSION="11" \
    PATH="/usr/lib/jvm/java-11-openjdk/bin:$PATH"
#copy artfacts
COPY target/ldap-server.jar /opt/ldap/ldap-server.jar
COPY src/main/resources/example.ldif /opt/ldap/ldif/example.ldif
#set workdir
WORKDIR /opt/ldap
#Ldap ports
EXPOSE 10389 10636

ENTRYPOINT java -jar ldap-server.jar $LDIF_FILE -p 10389 -sp 10636 -b 0.0.0.0