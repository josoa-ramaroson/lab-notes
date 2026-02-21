# step 1: create the destination buckets
aws s3api create-bucket --bucket xfusion-sync-22282 --region us-east-1
# or
aws s3 mb  s3://xfusion-sync-22282 --region us-east-1

# step 2: synchronise data between the source and destination buckets
aws s3 sync s3://xfusion-s3-5835 s3://xfusion-sync-22282 

# step 3:  Summarize and check data consistency
aws s3 ls s3://xfusion-s3-5835 --recursive --summarize
aws s3 ls s3://xfusion-sync-22282 --recursive --summarize