terraform {
  backend "s3" {
    bucket = "jm3-state"
    key    = "ec2-t4g-vault_consul-nodes.tfstate"
    region = "us-east-1"
    #dynamodb_table  = "jm3-state"
  }
}
