provider "aws" {
  version    = "~> 2.0"
  profile    = "default"
  region     = "us-east-1"
  shared_credentials_file = "/home/artemlavruschik/.aws/credentials"
  assume_role {
    role_arn     = "arn:aws:iam::242906888793:role/AWS_Sandbox"
    session_name = "AWS_Sandbox"
  }
}
