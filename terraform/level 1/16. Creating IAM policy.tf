# data "aws_iam_policy_document" "iampolicy_javed" {
#     statement {
#         actions = [
#             "ec2:Describe*",
#             "ec2:List*"
#         ]
#         resources = ["*"]
#     }
# } 

    resource "aws_iam_policy" "iampolicy_javed" {
        name = "iampolicy_javed"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = [
                        "ec2:Describe*",
                        "ec2:List*"
                    ]
                    Effect = "Allow"
                    Resource = "*"
                },
            ]
        })
    }