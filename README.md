
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Consumer Offset Commit Timeout.
---

This incident type refers to a situation where a Kafka consumer is unable to commit offsets within the specified timeout period. When a consumer receives messages from a Kafka topic, it needs to commit the offset of the last processed message to ensure that it doesn't consume the same messages again. However, if the consumer takes too long to commit the offset, it can cause delays and disrupt the normal functioning of the system. This can happen due to various reasons such as network issues, slow processing, or resource constraints.

### Parameters
```shell
export KAFKA_BROKER="PLACEHOLDER"

export CONSUMER_GROUP="PLACEHOLDER"

export PORT="PLACEHOLDER"

export NEW_TIMEOUT_DURATION_IN_MS="PLACEHOLDER"

export PATH_TO_KAFKA_DIRECTORY="PLACEHOLDER"

export PATH_TO_CONSUMER_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Step 1: Check if Kafka is running
```shell
systemctl status kafka
```

### Step 2: Check the Kafka topic and partition being consumed
```shell
kafka-consumer-groups --bootstrap-server ${KAFKA_BROKER}:${PORT} --describe --group ${CONSUMER_GROUP}
```

### Step 3: Check the offset lag for the Kafka topic and partition being consumed
```shell
kafka-consumer-groups --bootstrap-server ${KAFKA_BROKER}:${PORT} --describe --group ${CONSUMER_GROUP} | awk '{print $1,$6}'
```

### Step 5: Check if the Kafka consumer is committing offsets
```shell
kafka-consumer-groups --bootstrap-server ${KAFKA_BROKER}:${PORT} --describe --group ${CONSUMER_GROUP} | awk '{print $1,$5}'
```

### Step 6: Check the Kafka logs for any errors or warnings related to offsets
```shell
journalctl -u kafka | grep offset
```

## Repair

### Increase the timeout duration for Kafka Consumer Offset Commit.
```shell


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


```