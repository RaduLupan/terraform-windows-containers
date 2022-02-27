{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowECRandCWLogs",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }