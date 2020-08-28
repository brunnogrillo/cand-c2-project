provider "aws" {
    access_key = "AKIATLW4KIRSOZAXUCOS"
    secret_key = "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"
    region = "${var.aws_region}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "cloudwatch_policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attach_cloudwatch" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_cloudwatch_log_group" "loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.greet_lambda.function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "kms_policy" {
  name        = "kms_policy"
  description = "A KMS policy for lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:DescribeCustomKeyStores",
                "kms:ListKeys",
                "kms:DeleteCustomKeyStore",
                "kms:GenerateRandom",
                "kms:UpdateCustomKeyStore",
                "kms:ListAliases",
                "kms:DisconnectCustomKeyStore",
                "kms:CreateKey",
                "kms:ConnectCustomKeyStore",
                "kms:CreateCustomKeyStore"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "kms:*",
            "Resource": [
                "arn:aws:kms:*:*:alias/*",
                "arn:aws:kms:*:*:key/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attach_kms" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.kms_policy.arn
}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "lambda_function.py"
    output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "greet_lambda" {
  filename      = "lambda_function.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"

  runtime = "python3.7"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}