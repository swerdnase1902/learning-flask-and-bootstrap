# Build and run:
#   docker build -t flask_bootstrap -f Dockerfile .
#   docker run -d --cap-add sys_ptrace -p 2222:22 -p 5000:5000 -v "$(pwd):/project" --name flask_bootstrap flask_bootstrap
#   docker start flask_bootstrap
#   docker exec -it flask_bootstrap bash
#   ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2222"
#
# stop:
#   docker stop flask_bootstrap
#
# 
# ssh credentials (test user):
#   user@password 

FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y ssh \
      build-essential \
      python3 \
      python3-pip \
  && apt-get clean

RUN pip3 install flask

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_flask_bootstrap \
  && mkdir /run/sshd

RUN useradd -m user \
  && yes password | passwd user

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_flask_bootstrap"]

WORKDIR /project

