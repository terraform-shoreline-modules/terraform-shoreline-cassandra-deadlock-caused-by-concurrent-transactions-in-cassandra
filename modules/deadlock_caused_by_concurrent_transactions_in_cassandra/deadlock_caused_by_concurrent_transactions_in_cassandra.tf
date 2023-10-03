resource "shoreline_notebook" "deadlock_caused_by_concurrent_transactions_in_cassandra" {
  name       = "deadlock_caused_by_concurrent_transactions_in_cassandra"
  data       = file("${path.module}/data/deadlock_caused_by_concurrent_transactions_in_cassandra.json")
  depends_on = [shoreline_action.invoke_cassandra_table_contention_check,shoreline_action.invoke_config_cassandra]
}

resource "shoreline_file" "cassandra_table_contention_check" {
  name             = "cassandra_table_contention_check"
  input_file       = "${path.module}/data/cassandra_table_contention_check.sh"
  md5              = filemd5("${path.module}/data/cassandra_table_contention_check.sh")
  description      = "Multiple queries trying to access the same Cassandra table simultaneously, leading to contention and deadlock."
  destination_path = "/agent/scripts/cassandra_table_contention_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_cassandra" {
  name             = "config_cassandra"
  input_file       = "${path.module}/data/config_cassandra.sh"
  md5              = filemd5("${path.module}/data/config_cassandra.sh")
  description      = "Tune the Cassandra cluster settings to optimize performance and minimize the risk of deadlocks."
  destination_path = "/agent/scripts/config_cassandra.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cassandra_table_contention_check" {
  name        = "invoke_cassandra_table_contention_check"
  description = "Multiple queries trying to access the same Cassandra table simultaneously, leading to contention and deadlock."
  command     = "`chmod +x /agent/scripts/cassandra_table_contention_check.sh && /agent/scripts/cassandra_table_contention_check.sh`"
  params      = []
  file_deps   = ["cassandra_table_contention_check"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_table_contention_check]
}

resource "shoreline_action" "invoke_config_cassandra" {
  name        = "invoke_config_cassandra"
  description = "Tune the Cassandra cluster settings to optimize performance and minimize the risk of deadlocks."
  command     = "`chmod +x /agent/scripts/config_cassandra.sh && /agent/scripts/config_cassandra.sh`"
  params      = []
  file_deps   = ["config_cassandra"]
  enabled     = true
  depends_on  = [shoreline_file.config_cassandra]
}

