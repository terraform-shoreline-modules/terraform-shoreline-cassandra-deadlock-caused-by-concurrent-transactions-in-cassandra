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

module "deadlock_caused_by_concurrent_transactions_in_cassandra" {
  source    = "./modules/deadlock_caused_by_concurrent_transactions_in_cassandra"

  providers = {
    shoreline = shoreline
  }
}