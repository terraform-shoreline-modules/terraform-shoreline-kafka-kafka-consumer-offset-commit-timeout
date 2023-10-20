resource "shoreline_notebook" "kafka_consumer_offset_commit_timeout" {
  name       = "kafka_consumer_offset_commit_timeout"
  data       = file("${path.module}/data/kafka_consumer_offset_commit_timeout.json")
  depends_on = [shoreline_action.invoke_update_consumer_timeout]
}

resource "shoreline_file" "update_consumer_timeout" {
  name             = "update_consumer_timeout"
  input_file       = "${path.module}/data/update_consumer_timeout.sh"
  md5              = filemd5("${path.module}/data/update_consumer_timeout.sh")
  description      = "Increase the timeout duration for Kafka Consumer Offset Commit."
  destination_path = "/tmp/update_consumer_timeout.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_consumer_timeout" {
  name        = "invoke_update_consumer_timeout"
  description = "Increase the timeout duration for Kafka Consumer Offset Commit."
  command     = "`chmod +x /tmp/update_consumer_timeout.sh && /tmp/update_consumer_timeout.sh`"
  params      = ["PATH_TO_KAFKA_DIRECTORY","PATH_TO_CONSUMER_CONFIG_FILE","NEW_TIMEOUT_DURATION_IN_MS"]
  file_deps   = ["update_consumer_timeout"]
  enabled     = true
  depends_on  = [shoreline_file.update_consumer_timeout]
}

