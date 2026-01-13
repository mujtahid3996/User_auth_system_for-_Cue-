# Lambda execution role - Lambda function-কে AWS services ব্যবহারের অনুমতি দেয়।
resource "aws_iam_role" "lambda_role" {
  name = "${local.prefix}-auth-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Lambda function-কে CloudWatch Logs-এ log লেখার basic permission দেয়।
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda execution role-কে প্রয়োজনীয় AWS service access দেওয়ার জন্য এই policy তৈরি করা হয়।
resource "aws_iam_policy" "lambda_policy" {
  name = "${local.prefix}-auth-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Lambda-কে auth DynamoDB table-এ item যোগ করা ও পড়ার অনুমতি দেয়।
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.auth_table.arn
      },
      # Lambda-কে welcome notification topic-এ message publish করার অনুমতি দেয়।
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.welcome_topic.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_src/profile_creator.py"
  output_path = "${path.module}/profile_creator.zip"
}

resource "aws_lambda_function" "functions" {

  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${local.prefix}-profile-creator-function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "profile_creator.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.auth_table.name
      SNS_TOPIC_ARN = aws_sns_topic.welcome_topic.arn
    }
  }
}
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.functions.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user_pool.arn
}