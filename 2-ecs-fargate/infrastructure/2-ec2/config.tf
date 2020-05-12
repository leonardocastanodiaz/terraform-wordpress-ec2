resource "aws_s3_bucket_object" "get-docker-sh" {
  bucket       = "sbm-dev-terraform-state"
  key          = "swarm/config/get-docker.sh"
  source       = "config/get-docker.sh"
  content_type = "text/html"
  acl          = "private"
  etag         = "${md5(file("config/get-docker.sh"))}"
}

resource "aws_s3_bucket_object" "dev-swarm-key-pair" {
  bucket       = "sbm-dev-terraform-state"
  key          = "swarm/config/dev-swarm-key-pair"
  source       = "config/dev-swarm-key-pair"
  content_type = "text/html"
  acl          = "private"
  etag         = "${md5(file("config/dev-swarm-key-pair"))}"
}

