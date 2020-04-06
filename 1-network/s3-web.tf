resource "aws_s3_bucket" "rm-web" {
  bucket = "www.roommateflatfinder.com"
  acl = "public-read"
  policy = file("www.roommateflatfinder.com-s3-bucket-policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"

		 routing_rules = <<EOF
					[{
							"Condition": {
									"KeyPrefixEquals": "docs/"
							},
							"Redirect": {
									"ReplaceKeyPrefixWith": "index.html"
							}
					}]
					EOF
   }
}
resource "aws_s3_bucket_object" "upload-index" {
  bucket       = aws_s3_bucket.rm-web.bucket
  key          = "html"
  source       = "html"
  content_type = "text/html"
  acl          = "public-read"
}


resource "aws_s3_bucket_object" "upload-error" {
  bucket       = aws_s3_bucket.rm-web.bucket
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  acl          = "public-read"
  etag         = "${md5(file("index.html"))}"
}


resource "aws_s3_bucket" "rm-redirect" {
  bucket   = "roommateflatfinder.com"
  acl      = "public-read"

  website {
		redirect_all_requests_to = "http://www.roommateflatfinder.com/public/index.html"
  }
}
