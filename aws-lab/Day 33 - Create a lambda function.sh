# before creating the lambda function, make sure to have a role created
# get the ARN of the role with the command :
aws iam get-role --role-name <role name>

aws lambda create-function \
    --function-name <name of the lambda function> \
    --runtime <runtime identifier from the docs> \
    --role <ARN of the role> \
    --handler <filename.handlerMethod> \
    --zip-file fileb://<filepath>
