wget https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/containerd.io-1.6.33-3.1.el9.x86_64.rpm https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-buildx-plugin-0.19.3-1.el9.x86_64.rpm https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-ce-27.4.1-1.el9.x86_64.rpm https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-ce-cli-27.4.1-1.el9.x86_64.rpm https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-compose-plugin-2.32.1-1.el9.x86_64.rpm

sudo yum install containerd.io-1.6.33-3.1.el9.x86_64.rpm docker-buildx-plugin-0.19.3-1.el9.x86_64.rpm docker-ce-27.4.1-1.el9.x86_64.rpm docker-ce-cli-27.4.1-1.el9.x86_64.rpm docker-compose-plugin-2.32.1-1.el9.x86_64.rpm -y

sudo systemctl enable --now docker

sudo usermod -aG docker ec2-user

sysctl -w vm.max_map_count=524288

sysctl -w fs.file-max=131072

ulimit -n 131072

ulimit -u 8192

wget https://raw.githubusercontent.com/SonarSource/docker-sonarqube/refs/heads/master/example-compose-files/sq-with-postgres/docker-compose.yml

#Replace community by 9.9.8-community and pg_isready by pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER} in docker-compose.yaml
# fix the root role issue using this: https://github.com/peter-evans/docker-compose-healthcheck/issues/16

sed -i 's/community/9.9.8-community/g; s/pg_isready/pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}/g' docker-compose.yml

docker compose up
