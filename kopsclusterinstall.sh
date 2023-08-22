# add the user kops
sudo adduser kops
 sudo echo "kops  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kops
 sudo su - kops << EOF
 sudo apt update -y
# install awscli
 sudo apt install awscli -y 
# install kops software
sudo apt install wget -y
sudo wget https://github.com/kubernetes/kops/releases/download/v1.22.0/kops-linux-amd64
sudo chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
#install this if you are using a brand new EC2
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo 'ASSIGN Role kopsrole to the EC2'
sleep 2m
#create a role that you'll assign to the ec2 with the following permissions
#AmazonEC2FullAccess 
#AmazonS3FullAccess
#IAMFullAccess 
#AmazonVPCFullAccess
aws s3 mb s3://class34kops # need to be deleted at the end
aws s3 ls # to verify
# Give Unique Name And S3 Bucket which you created.
echo 'export NAME=class30.k8s.local' >> .bashrc
echo 'export KOPS_STATE_STORE=s3://class30kops' >> .bashrc
source .bashrc
echo $NAME
echo $KOPS_STATE_STORE
sleep 2m
kops create cluster --zones us-east-1a --networking weave --master-size t2.medium --master-count 1 --node-size t2.micro --node-count=2 --name ${NAME}
kops update cluster ${NAME} --yes
sleep 6m
kops export kubecfg $NAME --admin
kops validate cluster
kubectl get nodes 
EOF
