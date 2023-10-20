

#!/bin/bash



# Set the variables

KAFKA_HOME=${PATH_TO_KAFKA_DIRECTORY}

CONSUMER_CONFIG=${PATH_TO_CONSUMER_CONFIG_FILE}

TIMEOUT_DURATION=${NEW_TIMEOUT_DURATION_IN_MS}



# Update the consumer configuration with the new timeout duration

sed -i "s/offsets.commit.timeout.ms=.*/offsets.commit.timeout.ms=$TIMEOUT_DURATION/g" $CONSUMER_CONFIG



# Restart the Kafka Consumer service

$KAFKA_HOME/bin/kafka-consumer-service restart



# Check the status of the Kafka Consumer service

$KAFKA_HOME/bin/kafka-consumer-service status