FROM ubuntu:16.04
MAINTAINER "SKYDEVOPS" <syebbare@skydevops.in>

ENV TZ 'Asia/kolkata'

# Install dependencies.
RUN echo $TZ > /etc/timezone \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
python-software-properties \
software-properties-common \
rsyslog systemd systemd-cron sudo tzdata \
&& rm -Rf /var/lib/apt/lists/* \
&& rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
&& rm /etc/localtime \
&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&& dpkg-reconfigure -f noninteractive tzdata \
&& apt-get clean
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
#ADD etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf

# Install Ansible
RUN add-apt-repository -y ppa:ansible/ansible \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
ansible \
&& rm -rf /var/lib/apt/lists/* \
&& rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
&& apt-get clean

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts