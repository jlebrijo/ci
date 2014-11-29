# PRUN CI server = Base Server + Jenkins
# Suported by RVM and PhantomJS
FROM jlebrijo/base
MAINTAINER Juan Lebrijo "juan@lebrijo.com"

# DEPENDENCIES
RUN apt-get -y update

# JENKINS
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get -y update
RUN apt-get -y install jenkins

# PHANTOMJS
RUN apt-get install -y build-essential chrpath git-core libssl-dev libfontconfig1-dev libxft-dev

RUN git clone -b 1.9 --depth 1 git://github.com/ariya/phantomjs.git /root/phantomjs
WORKDIR /root/phantomjs
RUN ./build.sh --silent --confirm
RUN cp /root/phantomjs/bin/phantomjs /usr/local/bin/

# RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN chown -R jenkins:jenkins /usr/local/rvm

# Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/jenkins.conf