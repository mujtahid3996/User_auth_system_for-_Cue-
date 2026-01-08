# ==============================================================================
# AWS DynamoDB Table - Lambda থেকে তৈরি হওয়া ইউজার প্রোফাইলের তথ্য রাখে।
# বর্তমান Lambda-তে user_id, email এবং createdAt ফিল্ড লেখা হয়;
# অন্যান্য authentication data এখানে সংরক্ষণের configuration নেই।
# ==============================================================================
resource "aws_dynamodb_table" "auth_table" {
  name           = "${local.prefix}-users-table"
  
  # Billing Mode: PROVISIONED মানে এখানে রিড এবং রাইট ক্যাপাসিটি আগে থেকে নির্দিষ্ট করে দেওয়া হয়েছে।
  billing_mode   = "PROVISIONED"
  read_capacity  = 25
  write_capacity = 25

  # Hash Key: 'user_id' প্রতিটি আইটেমের partition key হিসেবে ব্যবহৃত হয়।
  hash_key = "user_id"

  attribute {
    name = "user_id"
    type = "S" # 'S' মানে String টাইপ ডাটা
  }
}
