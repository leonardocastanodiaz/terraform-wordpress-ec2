output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "nginx_tg_arn" {
  value = aws_alb_target_group.rm-www-nginx-tg.arn
}

output "roommates_uri" {
   value = "https://s3.eu-west-2.amazonaws.com/${aws_s3_bucket.rm-web.bucket}/${aws_s3_bucket_object.upload-index.id}"
  #value = "ssh -i jenkins-key-pair ubuntu@${aws_instance.jenkins-master.private_ip} -o 'proxycommand ssh -W %h:%p -i jenkins-key-pair ubuntu@${aws_instance.jenkins-bastion-host.public_ip}'"
}

output "roommates_redirect" {
  value = aws_s3_bucket.rm-redirect.bucket
}
