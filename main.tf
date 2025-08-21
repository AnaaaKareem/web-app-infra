module "vpc" {
    source = "./modules/vpc"
}

module "ec2" {
    source = "./modules/ec2"
    vpc_id = module.vpc.vpc_id
    cidr_block = module.vpc.cidr_block
    public_subnet_ids = module.vpc.public_subnet_ids
}

module "rds" {
    source = "./modules/rds"
    vpc_id = module.vpc.vpc_id
    private_subnet_ids = module.vpc.private_subnet_ids
    ami = module.ec2.ami
    ec2sg = module.ec2.ec2sg
    pub_ids = [ module.vpc.public_subnet_ids[0] ]
}

module "s3" {
    source = "./modules/s3"
    iam_ec2_arn = module.iam.iam_ec2_arn   
}

module "iam" {
  source = "./modules/iam"
  s3_arn = module.s3.s3_arn
  rds_arn = module.rds.sm_arn
}

terraform {
  backend "s3" {
    bucket         = "tfk-state"
    key            = "./terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    use_lockfile   = true
    encrypt        = true
  }
}