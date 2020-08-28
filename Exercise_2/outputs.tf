# TODO: Define the output variable for the lambda function.
output "greeting" {
  value = "${aws_lambda_function.greet_lambda.arn}"
}