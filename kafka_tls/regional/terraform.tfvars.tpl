##
#
# Variables
#

aws_profile = "manomano-__ENVIRONMENT__"
environment = "__ENVIRONMENT__"
aws_region  = "__REGION__"

kafka_version = "2.6.0"
instance_type = "kafka.m5.large"
ebs_volume_size = 500
number_of_broker_nodes = 3
config_name_suffix = "clust-config"

#kafka_server_properties = {
#  "auto.create.topics.enable"      = false,
#  "default.replication.factor"     = 3,
#  "min.insync.replicas"            = 2,
#  "num.io.threads"                 = 8,
#  "num.network.threads"            = 5,
#  "num.partitions"                 = 3,
#  "num.replica.fetchers"           = 1,
#  "replica.lag.time.max.ms"        = 30000,
#  "socket.receive.buffer.bytes"    = 102400,
#  "socket.request.max.bytes"       = 104857600,
#  "socket.send.buffer.bytes"       = 102400,
#  "unclean.leader.election.enable" = true,
#  "zookeeper.session.timeout.ms"   = 18000,
#  "auto.create.topics.enable"      = true,
#  "num.partitions"                 = 3
#  "replica.fetch.max.bytes"        = 104857600,
#  "message.max.bytes"              = 104857600
#}

