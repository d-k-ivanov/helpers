FROM amazonlinux

WORKDIR /tmp
RUN curl -sL https://rpm.nodesource.com/setup_6.x | bash - 	&& \
    yum install -y nodejs				&& \
    npm install -g npm@latest		&& \
    npm cache clean --force 		&& \
    yum install -y gcc-c++ make	&& \
    yum clean all

WORKDIR /build
