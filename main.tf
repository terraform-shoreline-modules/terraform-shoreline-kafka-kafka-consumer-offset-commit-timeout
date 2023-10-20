terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kafka_consumer_offset_commit_timeout" {
  source    = "./modules/kafka_consumer_offset_commit_timeout"

  providers = {
    shoreline = shoreline
  }
}