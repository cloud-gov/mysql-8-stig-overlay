# Dockerfile
FROM cincproject/auditor:latest

# Install MySQL client libraries
RUN apt-get update && \
    apt-get install -y default-mysql-client default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

# Manage ZScaler certs for GSA envs

#RUN if [ x"${BUILD_ENV}" = x"LOCAL" ] ; then cp /tmp/zscaler.crt /usr/local/share/ca-certificates/zscaler.crt ; update-ca-certificates ; fi
COPY .docker/zscaler_cert.pem /tmp/zscaler-root-ca.crt
RUN cp /tmp/zscaler-root-ca.crt /usr/local/share/ca-certificates/zscaler.crt && update-ca-certificates
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt




