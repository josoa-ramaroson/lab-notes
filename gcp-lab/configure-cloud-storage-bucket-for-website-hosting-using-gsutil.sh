BUCKET_NAME=qwiklabs-gcp-00-2cc17698a7fe-bucket

gsutil web set -m index.html -e error.html gs://$BUCKET_NAME
#gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME
gsutil uniformbucketlevelaccess set off gs://$BUCKET_NAME
gsutil -m acl set -R -a public-read gs://$BUCKET_NAME
gsutil defacl set public-read gs://$BUCKET_NAME
