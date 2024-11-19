resource "aws_db_subnet_group" "eaton-db-subnet-group" {
  name       = "eaton-db-subnet-group"
  subnet_ids = var.list_of_subnets
}

resource "aws_rds_cluster" "DBCluster" {
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  engine_version          = "5.7"
  availability_zones      = var.availability_zones
  cluster_identifier      = "eaton"
  master_username         = "eatonUser"
  master_password         = "FoxBravoSierra"
  
  db_subnet_group_name    = aws_db_subnet_group.eaton-db-subnet-group.name
  
  vpc_security_group_ids = var.list_of_SG
  backup_retention_period = 7
  skip_final_snapshot     = true

  kms_key_id = var.rds_kms_key_id_arn
  storage_encrypted   = true
  enabled_cloudwatch_logs_exports  = ["audit", "error",  "slowquery"]
  deletion_protection  = true
  
/*
    lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      availability_zones
    ]
    }*/
  
}

resource "aws_rds_cluster_instance" "DBClusterInstances" {
  identifier         = "eaton-${count.index}"
  count              = 2
  cluster_identifier = aws_rds_cluster.DBCluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.DBCluster.engine
  engine_version     = aws_rds_cluster.DBCluster.engine_version
  publicly_accessible = false
  
}

