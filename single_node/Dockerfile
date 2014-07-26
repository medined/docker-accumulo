FROM sroegner/doop

RUN curl -L http://www.poolsaboveground.com/apache/accumulo/1.6.0/accumulo-1.6.0-bin.tar.gz -o /tmp/acc.tgz && \
    tar xzf /tmp/acc.tgz -C /usr/lib && rm -vf /tmp/acc.tgz && id 

RUN ln -s /usr/lib/accumulo-1.6.0 /usr/lib/accumulo; \
    mkdir -p /etc/accumulo/conf /var/run/accumulo /var/lib/accumulo /var/log/accumulo; \
    useradd -u 6040 -G hadoop accumulo; \
    chown accumulo.accumulo /var/run/accumulo /var/lib/accumulo /var/log/accumulo; \
    rm -rf /usr/lib/accumulo/conf; rm -rf /usr/lib/accumulo/logs; \
    ln -s /etc/accumulo/conf /usr/lib/accumulo/conf; \
    ln -s /var/log/accumulo /usr/lib/accumulo/logs; 
    
RUN echo -e "\nvm.swappiness = 10" >> /etc/sysctl.conf; \
    echo "vm.overcommit_memory = 0" >> /etc/sysctl.conf; \
    echo "#disable ipv6" >> /etc/sysctl.conf; \
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf; \
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf; \
    echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

ADD . /docker
RUN cp -vr /docker/accumulo.conf/* /etc/accumulo/conf/; \
    cp -vr /docker/hadoop.conf/* /etc/hadoop/conf/; \
    cp /docker/accumulo_profile.sh /etc/profile.d/accumulo_profile.sh; \
    mkdir -p /root/.ssh /home/accumulo/.ssh; \
    chmod 700 /root/.ssh /home/accumulo/.ssh; \
    cp -vr /docker/dotssh/* /root/.ssh/; \
    cp -vr /docker/dotssh/* /home/accumulo/.ssh/ ;\
    chown -R accumulo.accumulo /home/accumulo/.ssh

EXPOSE 22 2181 8020 8025 8030 8050 8088 8141 10020 19888 50070 50090 50095

