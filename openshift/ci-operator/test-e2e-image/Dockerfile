FROM src

# Serverless operator tooling dependencies
RUN yum install -y httpd-tools
RUN wget -q https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# oc binary is injected by test steps to /cli dir + mask it as kubectl
RUN ln -s /cli/oc /usr/bin/kubectl

# Allow runtime users to add entries to /etc/passwd
RUN chmod g+rw /etc/passwd
