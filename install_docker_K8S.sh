apt-get update
apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
apt-get install docker-ce=5:20.10.5~3-0~ubuntu-bionic docker-ce-cli=5:20.10.5~3-0~ubuntu-bionic containerd.io

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

docker run hello-world

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-ip6tables = 1 
net.bridge.bridge-nf-call-iptables = 1 
EOF 

sysctl --system 

service docker restart 


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
chmod 777 /etc/apt/sources.list.d/kubernetes.list
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet=1.14.6-00 kubeadm=1.14.6-00  kubectl=1.14.6-00
apt-mark hold kubelet kubeadm kubectl
sysctl net.bridge.bridge-nf-call-iptables=1

sudo kubeadm init --pod-network-cidr=10.0.0.0/16 --apiserver-advertise-address=10.0.1.10
