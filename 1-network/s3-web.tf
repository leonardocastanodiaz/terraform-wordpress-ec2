resource "aws_s3_bucket" "rm-web" {
  bucket = "s3-website-test.roommateflatfinder.com"
  acl    = "public-read"
  policy = file("web-policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
    #redirect_all_requests_to = "index.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}



resource "aws_s3_bucket_object" "upload-index" {
  bucket       = "s3-website-test.roommateflatfinder.com"
  key          = "public/index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"
  etag         = "${md5(file("index.html"))}"
}


resource "aws_s3_bucket_object" "upload-error" {
  bucket       = "s3-website-test.roommateflatfinder.com"
  key          = "public/error.html"
  source       = "error.html"
  content_type = "text/html"
  acl          = "public-read"
  etag         = "${md5(file("index.html"))}"
}