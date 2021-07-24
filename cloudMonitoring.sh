#Create a Compute Engine Instance

gcloud beta compute \
          --project=qwiklabs-gcp-04-1112254c19a6 instances create lamp-1-vm \
          --zone=us-central1-a \
          --machine-type=n1-standard-2 \
          --subnet=default \
          --network-tier=PREMIUM \
          --maintenance-policy=MIGRATE \
          --service-account=617594893917-compute@developer.gserviceaccount.com \
          --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
          --tags=http-server \
          --image=debian-10-buster-v20210721 \
          --image-project=debian-cloud \
          --boot-disk-size=10GB \
          --boot-disk-type=pd-balanced \
          --boot-disk-device-name=lamp-1-vm \
          --no-shielded-secure-boot \
          --shielded-vtpm \
          --shielded-integrity-monitoring \
          --reservation-affinity=any \
gcloud compute 
          --project=qwiklabs-gcp-04-1112254c19a6 firewall-rules create default-allow-http \
          --direction=INGRESS \
          --priority=1000 \
          --network=default \
          --action=ALLOW \
          --rules=tcp:80 \
          --source-ranges=0.0.0.0/0 \
          --target-tags=http-server \

#SSH into Instance
gcloud compute ssh lamp-1-vm 
          --zone=us-central1-a \

#Set up Apache2 HTTP Server
sudo apt-get update
sudo apt-get install apache2 php7.0

#Install Cloud Logging Agent on VM Instances
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
sudo apt-get update
sudo apt-get install stackdriver-agent

#Run the Logging Agent install script command
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh
sudo apt-get update
