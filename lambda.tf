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

# IAM policy attachment for Lambda basic execution
# কাজ: Lambda function-এর সাথে CloudWatch Logs সংযোগ স্থাপন করে এবং
#      Lambda ফাংশনের stdout এবং stderr লগগুলো CloudWatch Logs-এ সংরক্ষণ করে।
#      এটি শুধুমাত্র "AWSLambdaBasicExecutionRole" policy attach করে।
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM policy for Lambda function - DynamoDB এবং SNS access দে৷
# কাজ:
#   - DynamoDB থেকে ডাটা পড়া (GetItem) এবং লিখা (PutItem) এর অনুমতি দেয়।
#   - ইউজার রেজিস্ট্রেশনের সময় ওয়েলকাম বার্তা পাঠানোর জন্য SNS publish এর অনুমতি দেয়।
#   - এই policy টি শুধুমাত্র Lambda function-এর জন্য এবং অন্য কোনো service-এর জন্য নয়।
resource "aws_iam_policy" "lambda_policy" {
  name = "${local.prefix}-auth-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.auth_table.arn
      },
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.welcome_topic.arn
      }
    ]
  })
}
