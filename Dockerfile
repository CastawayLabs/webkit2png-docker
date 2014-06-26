FROM debian:latest

RUN apt-get update
RUN apt-get install -y openssh-server python python-qt4 libqt4-webkit xvfb xbase-clients xfonts-base libgtk2.0-0
RUN apt-get install -y git python-setuptools python-pip
RUN pip install webkit2png

RUN apt-get install -y xorg openbox

RUN git clone git://github.com/adamn/python-webkit2png.git
WORKDIR python-webkit2png
RUN python setup.py install
RUN easy_install supervisor

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN echo 'root:webkit2png' | chpasswd

ADD supervisord.conf /etc/supervisord.conf

EXPOSE 22

CMD ["/usr/local/bin/supervisord"]
