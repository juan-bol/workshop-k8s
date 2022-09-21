# Kubernetes Workshop

Welcome!
In this workshop we will learn the basics about kubernetes.

We will:

1. Create a free kubernetes cluster.
2. Deploy a Pod and a service.
3. Learn about namespaces.
4. Create a Deployment and learn its advantages.

For this workshop, we will use the docker images hosted in https://hub.docker.com/r/jersondavidma/calculator-example

## 1. Connect to the cluster

There's a cluster already running in AWS EKS. You don't need to worry about how this cluster is configured. The only important thing here is that there is a Virtual machine with Kubectl installed, so you can start using the cluster.

```
ssh username@ip_address
```

The ip_address, the username and the password will be provided during the workshop.

Once connected run the command kubectl 
```
kubectl get nodes
```

## 2. Create a Pod and a Service

For now we will deploy a Pod and Service using the kubectl command line

1. Run pod using this command:

```
kubectl run my-name-calculator-example --image jersondavidma/calculator-example:v1
```

This will create a pod called `calculator-example` using the docker image `calculator-example:v1`. Check which Pods are running with the command

```
kubectl get pods
```

2. Right now the application in running, but we can't access it. To expose the application, create a new service running this command:

```
kubectl expose pods calculator-example --port=80 --target-port=8000 --type='NodePort' --name=calculator-example-service
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

The application should be running in your browser.

5. Delete the resources created in the step.

## 3. Create a Namespace, a Pod and a Service using a YAML file

We deployed the application using the command line. Now let's deploy it using a yaml file.

1. Open the file called [1.pod_service.yaml](k8s_manifests/1.pod_service.yaml) and copy it's content.
2. Create a new yaml file inside the master node of the cluster and paste its content.
3. run the command `kubectl apply -f name_of_file.yaml`.
4. You should check the all the resources were created:

```
kubectl get namespaces
kubectl get pods -n calculator-ns
kubectl get services -n calculator-ns
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
kubectl get deployments -n calculator-ns
kubectl get replicasets -n calculator-ns
kubectl get pods -n calculator-ns
kubectl get services -n calculator-ns
```

## 6. Let's play with the Deployment

Now that the deployment is running, let's make some test to see how it works.

1. List all the pods and select one. Run the command `kubectl delete pod pod_name -n calculator-ns`. The pod will be deleted. List again all the pods. You should see that kubernetes creates a new pod. This happens because the Deployment controller makes sure that the number of replica that you specified are the replicas running.

2. Change the number of replicas to scale up and scale down the number of pods. Apply the file again and see what happens with the number of pods.

## 7. Deploy a new Version

1. There's another version of the application in Dockerhub called `jersondavidma/calculator-example:v2`. Change the tag of the image in manifest to this new version and apply the changes.
2. Run the command `kubectl get pods -w  -n calculator-ns` and wait for a few seconds. See how kubernetes apply this changes.
3. Change the strategy to  **Recreate** and see how it changes the behavior. 

## 8. Add CPU and memory limits for the pods (Optional)

We can limit how much memory and CPU a single pod can use. Research about how to do it and implement it yourself. 


## Sample application

#### Endpoints for v1

```
GET /add?a=10&b=5
GET /subtract?a=10&b=5
GET /multiply?a=10&b=5
GET /divide?a=10&b=5
```

#### Endpoints for v2

```
GET /add?a=10&b=5
GET /subtract?a=10&b=5
GET /multiply?a=10&b=5
GET /divide?a=10&b=5
GET /pow?a=10&b=5
GET /modulo?a=10&b=5
```
