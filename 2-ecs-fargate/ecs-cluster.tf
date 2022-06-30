resource "aws_iam_role" "rm-ecs-iam-role" {
  name = "rm-ecs-iam-role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    },
    "Action": "sts:AssumeRole"
  }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rm-ecs-iam-role-policy" {
  name    = "rm-ecs-role-policy"
  role    = aws_iam_role.rm-ecs-iam-role.id

  policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ecr:*",
        "logs:*",
        "cloudwatch:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_ecs_cluster" "rm-cluster" {
  name = "rm-cluster"
  capacity_providers = ["FARGATE"]


  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 100
    base = 0

  }

  tags = {
    Name = "rm-cluster"
  }

}



