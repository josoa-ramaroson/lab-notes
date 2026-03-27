echo "Task1.create a storage bucket"
BUCKET_NAME="qwiklabs-gcp-01-fe65f785e239-kms_lab"
gsutil mb gs://${BUCKET_NAME}

echo "Task 2. Review the data" 
gsutil cp gs://${GOOGLE_CLOUD_PROJECT}-kms-lab-data/finance-dept/inbox/1.txt .
tail 1.txt

echo "Task 3. Enable Cloud KMS"
gcloud services enable cloudkms.googleapis.com

echo "Task 4. Create a KMS KeyRing and CryptoKey"
KEYRING_NAME=labkey CRYPTOKEY_NAME=qwiklab
gcloud kms keyrings create $KEYRING_NAME --location global
gcloud kms keys create $CRYPTOKEY_NAME --location global \
      --keyring $KEYRING_NAME \
      --purpose encryption

echo "Task 5. Encrypt your data"
PLAINTEXT=$(cat 1.txt | base64 -w0)
curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type: application/json"

echo "grab the output"
curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
  -d "{\"plaintext\":\"$PLAINTEXT\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type:application/json" \
| jq .ciphertext -r > 1.encrypted

echo "decrypt "
curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:decrypt" \
  -d "{\"ciphertext\":\"$(cat 1.encrypted)\"}" \
  -H "Authorization:Bearer $(gcloud auth application-default print-access-token)"\
  -H "Content-Type:application/json" \
| jq .plaintext -r | base64 -d

echo "Copy to the bucket"
gsutil cp 1.encrypted gs://${BUCKET_NAME}

echo "Task 6. Configure IAM permissions"
# get the usermail of the lab
USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
echo "Assign permission to manage KMS resources"
gcloud kms keyrings add-iam-policy-binding $KEYRING_NAME \
    --location global \
    --member user:$USER_EMAIL \
    --role roles/cloudkms.admin

echo "assign encryption permissions"
gcloud kms keyrings add-iam-policy-binding $KEYRING_NAME \
    --location global \
    --member user:$USER_EMAIL \
    --role roles/cloudkms.cryptoKeyEncrypterDecrypter

echo "Task 7. Back up data on the command line" 
gsutil -m cp -r gs://${GOOGLE_CLOUD_PROJECT}-kms-lab-data/finance-dept .

echo "encrypt each file from the google storage bucket"
MYDIR=finance-dept
FILES=$(find $MYDIR -type f -not -name "*.encrypted")
for file in $FILES; do
  PLAINTEXT=$(cat $file | base64 -w0)
  curl -v "https://cloudkms.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/global/keyRings/$KEYRING_NAME/cryptoKeys/$CRYPTOKEY_NAME:encrypt" \
    -d "{\"plaintext\":\"$PLAINTEXT\"}" \
    -H "Authorization:Bearer $(gcloud auth application-default print-access-token)" \
    -H "Content-Type:application/json" \
  | jq .ciphertext -r > $file.encrypted
done

echo "Copy the encrypted data to the bucket"
gsutil -m cp finance-dept/inbox/*.encrypted gs://${BUCKET_NAME}/finance-dept/inbox
