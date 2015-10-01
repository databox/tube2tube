FROM phusion/passenger-nodejs

RUN npm config set registry https://registry.npmjs.org/
RUN npm install -g pm2

RUN mkdir -p /etc/my_init.d
ADD docker/etc/my_init.d/npm_install.sh /etc/my_init.d/npm_install.sh
RUN chmod +x /etc/my_init.d/npm_install.sh

RUN mkdir -p /etc/service/tube2tube
ADD docker/etc/service/tube2tube/run /etc/service/tube2tube/run
RUN chmod +x /etc/service/tube2tube/run

# Space and place for mon
RUN mkdir /home/app/tube2tube
ADD . /home/app/tube2tube

RUN usermod -u 1000 app && \
    usermod -a -G sudo app && \
    usermod -a -G root app && \
    echo "app ALL=(ALL:ALL) ALL" >> /etc/sudoers

RUN cd /home/app/tube2tube && npm cache clean && npm install

# Clean cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
