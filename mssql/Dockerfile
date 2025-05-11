FROM mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YourStrong!Password123

USER root

COPY ./database /usr/setup
COPY entrypoint.sh /usr/entrypoint.sh

RUN chmod +x /usr/entrypoint.sh && \
    chown -R mssql /usr/entrypoint.sh

USER mssql

EXPOSE 1433

CMD /bin/bash /usr/entrypoint.sh 