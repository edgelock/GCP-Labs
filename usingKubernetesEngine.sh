#Set compute zone
gcloud config set compute/zone us-central1-a

#Download sample code
gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes .
cd orchestrate-with-kubernetes/kubernetes

#Create a cluster
gcloud container clusters create bootcamp \
          --num-nodes 5 \
          --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw" \

#Create a deployment
vi deployments/auth.yaml

#Start the editor
i

#Update the image in the container section of the deployment
...
containers:
- name: auth
  image: "kelseyhightower/auth:1.0.0"
...

#Save the auth .yaml file: press <Esc> then type:
:wq

#Examine the deployment configuration file
cat deployments/auth.yaml

#Create your deployment object using kubectl create:
kubectl create -f deployments/auth.yaml

#Verify what was created:
kubectl get deployments

#Verify the ReplicaSet
kubectl get replicasets

#Review the Pods that were created as par of the deployment
kubectl get pods

#Create a service for your auth deployment
kubectl create -f services/auth.yaml

#Same thing to create and expose the hello Deployment
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

#One more time to create and expose the frontend Deployment
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

#Interact with the frontend by grabbbing its external IP and curling to it
kubectl get services frontend
curl -ks https://<EXTERNAL-IP>

#Now that we have a Deployment created we can scale it by updating the spec.replicas field
kubectl scale deployment hello --replicas=5

#Verify that there at 5 pods running:
kubectl get pods | grep hello- | wc -l

#Scale back down the application
kubectl scale deployment hello --replicas=3

#Verify that it scaled down
kubectl get pods | grep hello- | wc -l

#Time to trigger a rolling update
#Update your Deployment
kubectl edit deployment hello

#Change image to the following:
...
containers:
  image: kelseyhightower/hello:2.0.0
...

#See the new REplicaSet that kubernetes creates:
kubectl get replicaset

#Create a new canary deployment for the new version:
cat deployments/hello-canary.yaml

#Create the new canary deployment
kubectl create -f deployments/hello-canary.yaml

#After it is created you should have 2 different deployments; double check
kubectl get deployments

#Verify the version being served by the canary deployment
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version