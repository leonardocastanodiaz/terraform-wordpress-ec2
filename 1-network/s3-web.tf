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




