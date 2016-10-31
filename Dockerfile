FROM debian:jessie

ENV CONFIG_DIR /opt/config
ENV SUPERVISOR_CONF ${CONFIG_DIR}/supervisord.conf
ENV FRESHCLAM_UPDATE 2

ADD ./config /etc/supervisor/
ADD ./start_clamav.sh /opt/

RUN apt-get update && \
    apt-get install -y \
        clamav clamav-daemon python gcc musl-dev python-pip wget && \

# Install Supervisor.
    easy_install supervisor && \

# Create folders and set proper permissions   
    mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav && \
    mkdir -p /var/lib/clamav/ && \
    chown -R clamav:clamav /var/lib/clamav/ && \
    rm -rf /var/lib/apt/lists/* && \
    
# Create logs directory
    mkdir -p  /var/log/supervisor && \
    chmod -R 0777 /var/log/supervisor && \

# Make the start-script executable.
    chmod +x /opt/start_clamav.sh && \

# Make clam and fresh to be run on forground so that supervisor take care of the rest
    sed -i 's/^Foreground false/Foreground true/g' /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground false/Foreground true/g' /etc/clamav/freshclam.conf && \

# Make clam listen to remote socker and not unix socket
   sed -i 's/^LocalSocket \/var\/run\/clamav\/clamd.ctl//g' /etc/clamav/clamd.conf && \
   echo "TCPSocket 3310 " >> /etc/clamav/clamd.conf && \

# Fetch db when building the container in order to save time on starting the service
    freshclam --stdout 

EXPOSE 3310

VOLUME [ "/opt/files", "/opt/config", "/var/log/supervisor" ]
WORKDIR /opt

CMD [ "supervisord",  "-c",  "/etc/supervisor/supervisord.conf", "-n"]
