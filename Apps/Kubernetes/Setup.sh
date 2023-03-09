# -------==========-------
# Tips
# -------==========-------
# Go from Docker Compose to Kubernetes
curl -L https://github.com/kubernetes/kompose/releases/download/v1.21.0/kompose-darwin-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
source <(kompose completion zsh)
kompose convert --provider=openshift
# -------==========-------
# Disable SWAP
# -------==========-------
sudo swapon -s
sudo swapoff -a
#sudo nano /etc/fstab
sudo reboot
# -------==========-------
# K8S
# -------==========-------
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm version
# -------==========-------
# Config Master
# -------==========-------
sudo hostnamectl set-hostname ED-Master
echo -e "127.0.0.1 ED-Master" | sudo tee -a /etc/hosts
# Usual Ubuntu
sudo nano /etc/hosts  
127.0.0.1    ED-Master
37.156.28.37    ED-Worker01
# Cloud-init Ubuntu
sudo nano /etc/cloud/templates/hosts.debian.tmpl
127.0.0.1 ibWorker1
127.0.0.1 pb1.legace.ir

sudo reboot
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all --apiserver-advertise-address=37.156.28.38
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl get pods --all-namespaces
sudo chown -R $USER $HOME/.kube

mkdir -p /home/$USER/.kube
cp -i /etc/kubernetes/admin.conf /home/$USER/.kube/config
chown $USER:$USER /home/$USER/.kube/config  
# -------==========-------
# Config Worker
# -------==========-------
sudo hostnamectl set-hostname ED-Worker01
echo -e "37.156.28.38 ED-Master" | sudo tee -a /etc/hosts
echo -e "127.0.0.1 ED-Worker01" | sudo tee -a /etc/hosts

sudo reboot
# -------==========-------
sudo kubeadm join 37.156.28.38:6443 --token zwduop.wh43ecfog4axbl7n \
    --discovery-token-ca-cert-hash sha256:544dc043005a30abe6e2e7c657703b3560435d503a0dc09f9e302203ca0fd5d6 
# -------==========-------
kubectl get nodes
# -------==========-------
# Auto Completion ZSH
# -------==========-------
source <(kubectl completion zsh)
echo 'alias  d=docker' >>~/.zshrc
echo 'alias k=kubectl' >>~/.zshrc
echo 'complete -F __start_kubectl k' >>~/.zshrc

# -------==========-------
# Helm
# -------==========-------
curl https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
# -------==========-------
# Remove
# -------==========-------
sudo kubeadm reset -f
noglob sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*   
sudo apt-get autoremove  
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/
sudo iptables -F && sudo iptables -X
sudo iptables -t nat -F && sudo iptables -t nat -X
sudo iptables -t raw -F && sudo iptables -t raw -X
sudo iptables -t mangle -F && sudo iptables -t mangle -X
sudo systemctl restart docker