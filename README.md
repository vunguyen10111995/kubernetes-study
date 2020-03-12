# Kubernetes Example Production Server

First, u can install docker, kubernetes on your server. If not, you can follow in environment.sh file.
And you must disable swap memory.

# Let's go!

### 1. Init Kubeadm

```
$ kubeadm init --pod-network-cidr=192.168.0.0/16
```

## 2. Install a Pod network add-on

In environment production, you must deploy CNI (Container Network Interface). So your Pods can communicate with each other

You can find and use CNIs in [Install a Pod network add-on](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network).

I am using Calico in this example

```
kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
```

## 3. Setup Cluster (from master)

```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ export KUBECONFIG=/etc/kubernetes/admin.conf
```

## 4. Join in the cluster (from node)

```
$ kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

Check nodes:

```
$ kubectl get nodes -A
```

-A: --all-namespace
If all nodes is ready. You can successfully.

## 5. Run deployment.yaml file

In this step, we will deployment services using nginx images.
We have a concept is `Ingress`. It uses to forward traffic request from outside(client) to services in nodes. You must use ingress if access from external IP of server.
Run deployment:

```
$ kubectl apply -f deployment.yaml
```

The, you can using command below to check deployments, pods, services, and everythings

```
$ kubectl get all -n hotel
```

-n: namespace
In this case, we will create a namespace is named `hotel`.
And you can see `ingress` part in `deployment.yaml`. I have a domain `hotel.example.com` was tagged service `hotel-svc`. Service `hotel-svc` was created in `service` head.

Get node instance of service:

```
$ kubectl get pods -o wide
```

In node, you can curl to IP of output pods.

You need config nginx to reverse proxy to <ipInternalNode>:<port>. See in file nginx.conf.

Finally, you add external IP in your local computer in /etc/hosts:

```
ip.xx.xx.xx hotel.example.com
```

In browser you can enter url `hotel.example.com` and see nginx.

# Next

Use configMaps and haproxy to extends kubernetes
