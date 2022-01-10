FROM amazoncorretto:8u312-alpine3.15

ENV LANG C.UTF-8

ENV PAYARA_RELEASE_MAJOR_RELEASE=5
ENV PAYARA_RELEASE=5.2021.10
ENV PAYARA_HOME=/opt/payara${PAYARA_RELEASE_MAJOR_RELEASE}
ENV LOGBACK_BUNDLE_VERSION=1.1.0
ENV PATH="${PATH}:${PAYARA_HOME}/bin"
ENV DOMAIN_NAME=domain1
ENV PAYARA_DOMAIN_HOME=${PAYARA_HOME}/glassfish/domains/${DOMAIN_NAME}
ENV REPO_URL=https://repo1.maven.org/maven2

# Install Payara
RUN true \
    && cd tmp \
    && wget --quiet --no-check-certificate ${REPO_URL}/fish/payara/distributions/payara/${PAYARA_RELEASE}/payara-${PAYARA_RELEASE}.zip \
	&& unzip payara-${PAYARA_RELEASE}.zip \
    && mv payara${PAYARA_RELEASE_MAJOR_RELEASE} /opt \
    && rm -rf payara-${PAYARA_RELEASE}.zip \
    && true

# Configure Payara
COPY payara-logback-libs/target/payara-logback-libs-1.0.0-SNAPSHOT.jar ${PAYARA_DOMAIN_HOME}/lib/ext/
COPY payara-logback-osgi/target/payara-logback-osgi-1.0.0-SNAPSHOT-nodeps.jar ${PAYARA_HOME}/glassfish/modules/
COPY docker-image/logging.properties ${PAYARA_DOMAIN_HOME}/config/
COPY docker-image/logback.xml ${PAYARA_DOMAIN_HOME}/config/
COPY docker-image/domain.xml ${PAYARA_DOMAIN_HOME}/config/
COPY docker-image/startup.sh ${PAYARA_HOME}/
RUN chmod 777 ${PAYARA_HOME}/startup.sh

# Deploy Application
COPY sample-app/target/sample-app-1.0.0-SNAPSHOT.war ${PAYARA_DOMAIN_HOME}/autodeploy/sample-app.war

WORKDIR ${PAYARA_HOME}

EXPOSE 8080
EXPOSE 8181
EXPOSE 4848

ENTRYPOINT ["sh", "startup.sh"]