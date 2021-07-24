#Create a pubsub topic
gcloud pubsub topics create myTopic

#Create 2 more test topics
gcloud pubsub topics create Test1
gcloud pubsub topics create Test2

#Delete the test topics
gcloud pubsub topics delete Test1
gcloud pubsub topics delete Test2

#List all available topics
gcloud pubsub topics list

#Create a subscription
gcloud  pubsub subscriptions create \
          --topic myTopic mySubscription

#Add 2 more scubscriptions to "myTopic" topic
gcloud  pubsub subscriptions create \
         --topic myTopic Test1
gcloud  pubsub subscriptions create \
         --topic myTopic Test2

#List all available topics
gcloud pubsub topics list-subscriptions myTopic

#Delete Test1 & Test2
gcloud pubsub subscriptions delete Test1
gcloud pubsub subscriptions delete Test2

#Check if they were deleted
gcloud pubsub topics list-subscriptions myTopic

#publish the message "Hello" to "myTopic" topic
gcloud pubsub topics publish myTopic \
          --message "Hello"

#Publish other test topics
gcloud pubsub topics publish myTopic \
          --message "Publisher's name is <YOUR NAME>"

gcloud pubsub topics publish myTopic \
          --message "Publisher likes to eat <FOOD>"

gcloud pubsub topics publish myTopic \
          --message "Publisher thinks Pub/Sub is awesome"

#Use the "pull" command to pull your messages from your topic
gcloud pubsub subscriptions pull mySubscription \
          --auto-ack


#Using the pull command without any flags will output only one message, even if you are subscribed to a topic that has more held in it.
#Once an individual message has been outputted from a particular subscription-based pull command, you cannot access that message again with the pull command.
#To get the other messages run the previous command 3 more times.
#If you run the command 4 times you will get 0 listed items because you have went through all your posted topics.

#Populate "myTopic" with more topics
gcloud pubsub topics publish myTopic \
          --message "Publisher is starting to get the hang of Pub/Sub"
gcloud pubsub topics publish myTopic \
          --message "Publisher wonders if all messages will be pulled"
gcloud pubsub topics publish myTopic \
          --message "Publisher will have to test to find out"

#Run the pull command with the limit flag to get all of the newly posted topics
gcloud pubsub subscriptions pull mySubscription \
          --auto-ack \
          --limit=3 \