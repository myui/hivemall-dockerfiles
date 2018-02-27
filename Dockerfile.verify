#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM openjdk:7-alpine
MAINTAINER Makoto Yui <myui@apache.org>

ENV VERSION=0.5.0
ENV RC_NUMBER=3

ENV JAVA_HOME=/usr/lib/jvm/java-1.7-openjdk
ENV JAVA8_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV MAVEN_OPTS=-XX:MaxPermSize=256m

WORKDIR /work

RUN set -eux && \
    apk update && apk add --no-cache ca-certificates && update-ca-certificates && \
    apk add --no-cache openjdk8 bash gnupg coreutils wget maven zip && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-2.27-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-bin-2.27-r0.apk && \
    apk add --no-cache glibc-2.27-r0.apk glibc-bin-2.27-r0.apk && \
    wget https://raw.githubusercontent.com/apache/incubator-hivemall/master/KEYS && \
    gpg --import KEYS && \
    wget https://raw.githubusercontent.com/myui/hivemall-dockerfiles/master/bin/build_from_src.sh && \
    chmod +x build_from_src.sh && ./build_from_src.sh && \
    rm -rf /work/${VERSION}-incubating-rc${RC_NUMBER} && \
    rm -rf rm -rf /var/cache/apk/* /tmp/* /work/*.apk

VOLUME ["/tmp", "/mnt/host/tmp"]

CMD ["bash"]
