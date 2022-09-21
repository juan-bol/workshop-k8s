# Kubernetes Workshop

Welcome!
In this workshop we will learn the basics about kubernetes.

We will:

1. Create a free kubernetes cluster.
2. Deploy a Pod and a service.
3. Learn about namespaces.
4. Create a Deployment and learn its advantages.

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

Copy this output to a safe place, we'll need it later. Then, run the second command.

5. Add two new instances and paste the last command we found in the previous step in each instance

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


## 2. Create a Pod and a Service

For now we will simply deploy a Pod and Service using the kubectl command line

1. Run pod using this command:

```
kubectl run calculator-example --image jersondavidma/calculator-example:v1
```

This will create a pod called `calculator-example` using the docker image `calculator-example:v1`

2. Right now the application in running, but we can't access it. To expose the application, create a new service running this command:

```
kubectl expose pods calculator-example --port=80 --target-port=80 --type='NodePort' --name=calculator-example-service
```

3. To list all the services, run the command `kubectl get services`. You'll get an output like this:

```
NAME                            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes                      ClusterIP   10.96.0.1       <none>        443/TCP        28m
calculator-example-service      NodePort    10.103.65.167   <none>        80:31934/TCP   3s
```

You'll see the Service we just created right there. See the PORT(S) columns. Take note of the second port, in this case, `31934`.

4. Navigate to one of the nodes urls and the port. For example:

```
ip172-18-0-21-ccl3uukhtugg00877tk0.direct.labs.play-with-k8s.com:31934
```

Now the application will be running.

## 3. Create a Pod and a Service using a YAML file

We deployed the application using the command line. Now let's deploy it using a yaml file.

1. Open the file called [1.pod_service.yaml](k8s_manifests/1.pod_service.yaml) and copy it's content.
2. Create a new yaml file inside the master node of the cluster and paste its content.
3. run the command `kubectl apply -f name_of_file.yaml`.
4. You should check the all the resources were created:

```
kubectl get namespaces
kubectl get pods
kubectl get services
```

## 4. Change the port where the application is running (Optional)

The application by default is running in the port 8000 inside the pod. This can be changed updating the environment variable called `PORT`.

1. Update the Pod manifest to add this environment variable to the Pod.
2. Update the Service to reflect this change.


## 5. Create a Deployment

Usually a single pod is not enough. Let's create a Deployment object.

1. Open the file [2.deployment.yaml](k8s_manifests/2.deployment.yaml). 
2. Complete the missing information in this file.
3. Create a new yaml file inside the master node of the cluster and paste its content.
4. run the command `kubectl apply -f name_of_file.yaml`.
5. You should check the all the resources were created:

```
kubectl get namespaces
kubectl get pods
kubectl get deployments
kubectl get replicasets
kubectl get services
```

## 6. Let's play with the Deployment

Now that the deployment is running, let's make some test to see how it works.

1. List all the pods and select one. Run the command `kubectl delete pod pod_name`. The pod will be deleted. List again all the pods. You should see that kubernetes creates a new pod. This happens because the Deployment controller makes sure that the number of replica that you specified are the replicas running.

2. Change the number of replicas to scale up and scale down the number of pods. Apply the file again and see what happens with the number of pods.

## 7. Deploy a new Version

1. There's another version of the application in dockerhub called `jersondavidma/calculator-example:v2`. Change the tag of the image in manifest to this new version and apply the changes.
2. Run the command `kubectl get pods -w ` and wait for a few seconds. See how kubernetes apply this changes.
3. Change the strategy to  **Recreate** and see how it changes the behavior. 


## Sample application


#### Routes for v1

```
GET /add?a=10&b=5
GET /subtract?a=10&b=5
GET /multiply?a=10&b=5
GET /divide?a=10&b=5
```

#### Routes for v2

```
GET /add?a=10&b=5
GET /subtract?a=10&b=5
GET /multiply?a=10&b=5
GET /divide?a=10&b=5
GET /pow?a=10&b=5
GET /modulo?a=10&b=5
```
