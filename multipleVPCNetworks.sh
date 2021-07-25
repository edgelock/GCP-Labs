#Creame custome mode VPC netowrks with firewall rules
gcloud compute networks create managementnet \
          --project=qwiklabs-gcp-04-0231c2a6cd9f \
          --subnet-mode=custom \
          --mtu=1460 \
          --bgp-routing-mode=regional \

gcloud compute networks subnets create managementsubnet-us \
          --project=qwiklabs-gcp-04-0231c2a6cd9f \
          --range=10.130.0.0/20 \
          --network=managementnet \
          --region=us-central1 \

#Create the privatenet network
gcloud compute networks create privatenet \
          --subnet-mode=custom \

#Create the privatesubnet-us subnet
gcloud compute networks subnets create privatesubnet-us \
          --network=privatenet \
          --region=us-central1 \
          --range=172.16.0.0/24 \

#Create the privatesubnet-eu subnet:
gcloud compute networks subnets create privatesubnet-eu \
          --network=privatenet \
          --region=europe-west4 \
          --range=172.20.0.0/20 \

#List ass created networks
gcloud compute networks list

#List all available VPC subnets:
gcloud compute networks subnets list \
          --sort-by=NETWORK \

#Create Firewall rules for managementnet
gcloud compute 
          --project=qwiklabs-gcp-00-65d91de4ece9 firewall-rules create managementnet-allow-icmp-ssh-rdp \
          --direction=INGRESS \
          --priority=1000 \
          --network=default \
          --action=ALLOW \
          --rules=tcp:22,tcp:3389,icmp \
          --source-ranges=0.0.0.0/0 \

#Create firewall rules for privatenet
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp \
          --direction=INGRESS \
          --priority=1000 \
          --network=privatenet \
          --action=ALLOW \
          --rules=icmp,tcp:22,tcp:3389 \
          --source-ranges=0.0.0.0/0 \

#List all firewall rules 
gcloud compute firewall-rules list \
          --sort-by=NETWORK \

#Create VM Instances
gcloud beta compute 
          --project=qwiklabs-gcp-00-65d91de4ece9 instances create managementnet-us-vm \
          --zone=us-central1-f \
          --machine-type=f1-micro \
          --subnet=managementsubnet-us \
          --network-tier=PREMIUM \
          --maintenance-policy=MIGRATE \
          --service-account=259116033400-compute@developer.gserviceaccount.com \
          --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
          --image=debian-10-buster-v20210721 \
          --image-project=debian-cloud \
          --boot-disk-size=10GB \
          --boot-disk-type=pd-balanced \
          --boot-disk-device-name=managementnet-us-vm \
          --no-shielded-secure-boot \
          --shielded-vtpm \
          --shielded-integrity-monitoring \
          --reservation-affinity=any \

#Create privatenet-us-vm instance
gcloud compute instances create privatenet-us-vm \
          --zone=us-central1-f \
          --machine-type=n1-standard-1 \
          --subnet=privatesubnet-us \

#List all VM by zone
gcloud compute instances list \
          --sort-by=ZONE \

#Ping mynet-eu vm, managementnet-us-vm and privatenet-us-vm
ping -c 3 34.71.64.199
ping -c 3 35.224.13.208
ping -c 3 35.224.13.208

#Creat a vm instance with multiple network interfaces
gcloud beta compute \
          --project=qwiklabs-gcp-00-65d91de4ece9 instances create vm-appliance \
          --zone=us-central1-f \
          --machine-type=n1-standard-4 \
          --subnet=privatesubnet-us \
          --network-tier=PREMIUM \
          --maintenance-policy=MIGRATE \
          --service-account=259116033400-compute@developer.gserviceaccount.com \
          --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
          --image=debian-10-buster-v20210721 \
          --image-project=debian-cloud \
          --boot-disk-size=10GB \
          --boot-disk-type=pd-balanced \
          --boot-disk-device-name=vm-appliance \
          --no-shielded-secure-boot \
          --shielded-vtpm \
          --shielded-integrity-monitoring \
          --reservation-affinity=any \

#Ssh to vm-appliance
gcloud compute ssh example-instance \
          --zone=us-central1-a \

#Get all network interfaces within the VM instance:
gcloud compute ssh example-instance \
          --zone=us-central1-a \

#Test connectivity to managementnet-us-vm, mynet-us-vm, and mynet-eu-vm
ping -c 3 <Enter managementnet-us-vm's internal IP here>
ping -c 3 <Enter mynet-us-vm's internal IP here>
ping -c 3 <Enter mynet-eu-vm's internal IP here>