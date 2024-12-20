#update the system
sudo apt update -y
# add the user kops
sudo adduser --disabled-password kops
sudo echo "kops  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kops
sudo su - kops << EOF
# install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
# install kops software
sudo apt install wget -y
sudo wget https://github.com/kubernetes/kops/releases/download/v1.22.0/kops-linux-amd64
sudo chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
#install this if you are using a brand-new EC2
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo 'ASSIGN Role kopsrole to the EC2 in case you forgot. You have about 2 mins'
sleep 2m
#create a role that you'll assign to the ec2 with the following permissions
#AmazonEC2FullAccess 
#AmazonS3FullAccess
#IAMFullAccess 
#AmazonVPCFullAccess
aws s3 mb s3://class32kopspat # need to be deleted at the end
aws s3 ls
# initialize variable
# Give Unique Name And S3 Bucket which you created.
echo 'export NAME=class32.k8s.local' >> .bashrc
echo 'export KOPS_STATE_STORE=s3://class32kopspat' >> .bashrc
echo 'initializing the kops cluster'
#export NAME="class32.k8s.local"
export KOPS_STATE_STORE=s3://class32kopspat
echo 'showing the content of the variables'
#echo $NAME
echo $KOPS_STATE_STORE
kops create cluster --zones us-east-1a --networking weave --master-size t2.medium --master-count 1 \
--node-size t2.micro --node-count=2 \
--name class32.k8s.local --state s3://class32kopspat
echo 'UPDATE Cluster'
kops update cluster class32.k8s.local --yes
sleep 6m
kops export kubecfg class32.k8s.local --admin
kops validate cluster
kubectl get nodes 
### DELETE THE CLUSTER BY USING : kops delete cluster --name=${NAME} --state=${KOPS_STATE_STORE} --yes
EOF
### MAKE SURE TO ASSIGN THE KOPS ROLE TO THE EC2 BEFORE YOU START THIS SCRIPT####
