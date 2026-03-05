# 
aws lambda create-function \
    --function-name <your-function-name> \
    --runtime <runtime-identifier> \
    --role <iam-execution-role-arn> \
    --handler <file_name.handler_method> \
    --zip-file fileb://<path-to-your-zip-file>
