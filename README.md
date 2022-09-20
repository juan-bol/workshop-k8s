# Kubernetes Workshop

Welcome!
In this workshop we will learn the basics about kubernetes.

We will:

1. Create a free kubernetes cluster.
2. Deploy a Pod and a service.
3. Learn about namespaces.
4. Create a Deployment and learn its advantages.
5. Learn about service discovery capabilities.

## 1. Create a new cluster

There are many ways to create a Kubernetes cluster. For this workshop we are going to use a simple cluster provided by Docker. https://labs.play-with-k8s.com/.

1. Once in the page, login using a github or a Docker account and click Start.
2. Create a new intance clicking in the button ADD NEW INSTANCE. A new terminal will openned.
3. This first instance will be the Master Node. Run the first two commands that it shows. 
```
 1. Initializes cluster master node:

 kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

 2. Initialize cluster networking:

kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

```

4. After you run the first command, you'll get an output like this,

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.0.23:6443 --token wk4tqn.4ta8xgm7jr0i93ng \
    --discovery-token-ca-cert-hash sha256:3ebb5b8c797e372d86da880d60035b6173a6913b8f79ee05d37acf09c6354921 
```

Copy this output to a safe place, we'll need it later. 

5. Add two new instances and paste the last command we found in the previous step

```
kubeadm join 192.168.0.23:6443 --token wk4tqn.4ta8xgm7jr0i93ng \
    --discovery-token-ca-cert-hash sha256:3ebb5b8c797e372d86da880d60035b6173a6913b8f79ee05d37acf09c6354921 
```

This will register both instances as worker nodes to the cluster.

6. Now we have a three nodes cluster. Once instance is the master nodes, and the other 2 are worker nodes. Run the command  `kubectl get nodes` to view the available nodes in the cluster. The output should be something like this:

```
NAME    STATUS   ROLES                  AGE     VERSION
node1   Ready    control-plane,master   8m59s   v1.20.1
node2   Ready    <none>                 3m      v1.20.1
node3   Ready    <none>                 2m58s   v1.20.1
```

**Note:** You may need to wait for a few seconds before the nodes becomes available. 


## 2. Deploy a Pod and a Service

For now we will simply deploy a Pod and Service using the kubectl command line

1. Run pod using this command:

```
kubectl run nginx-pod --image nginx:latest
```

This will create a pod called `nginx-pod` using the docker image `nginx:latest`

2. Right now the application in running, but we can't access it. To expose the application, create a new service running this command:

```
kubectl expose pods nginx-pod --port=80 --target-port=80 --type='NodePort' --name=my-service
```

3. To list all the services, run the command `kubectl get services`. You'll get an output like this:

```
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        28m
my-service   NodePort    10.103.65.167   <none>        80:31934/TCP   3s
```

You'll see the Service we just created right there. See the PORT(S) columns. Take note of the second port, in this case, `31934`.

4. Navigate to one of the nodes urls and the port. For example:

```
ip172-18-0-21-ccl3uukhtugg00877tk0.direct.labs.play-with-k8s.com:31934
```

Now the application will be running.

## Sample application

#### Routes for v1

```
http://hostname:8000/add?a=10&b=5
http://hostname:8000/subtract?a=10&b=5
http://hostname:8000/multiply?a=10&b=5
http://hostname:8000/divide?a=10&b=5
```

#### Routes for v2

```
http://hostname:8000/add?a=10&b=5
http://hostname:8000/subtract?a=10&b=5
http://hostname:8000/multiply?a=10&b=5
http://hostname:8000/divide?a=10&b=5
http://hostname:8000/pow?a=10&b=5
http://hostname:8000/modulo?a=10&b=5
```