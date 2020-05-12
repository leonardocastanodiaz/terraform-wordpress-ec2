### AWS Lambda function ###
# AWS Lambda API requires a ZIP file with the execution code
data "archive_file" "ec2_start_scheduler_lambda" {
  type        = "zip"
  source_file = "start_instances.py"
  output_path = "start_instances.zip"
}

data "archive_file" "stop_scheduler" {
  type        = "zip"
  source_file = "stop_instances.py"
  output_path = "stop_instances.zip"
}

# Lambda defined that runs the Python code with the specified IAM role
resource "aws_lambda_function" "ec2_start_scheduler_lambda" {
  filename         = data.archive_file.stop_scheduler.output_path
  function_name    = "start_instances"
  role             = aws_iam_role.ec2_role.id
  handler          = "start_instances.lambda_handler"
  runtime          = "python2.7"
  timeout          = 300
  source_code_hash = "${filebase64sha256("start_instances.zip")}"
}

resource "aws_lambda_function" "ec2_stop_scheduler_lambda" {
  filename         = data.archive_file.stop_scheduler.output_path
  function_name    = "stop_instances"
  role             = aws_iam_role.ec2_role.id
  handler          = "stop_instances.lambda_handler"
  runtime          = "python2.7"
  timeout          = 300
  source_code_hash = "${filebase64sha256("stop_instances.zip")}"

}