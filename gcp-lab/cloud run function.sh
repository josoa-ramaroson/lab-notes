echo "Task 1. create a functions"
gcloud config set run/region us-east4
mkdir gcf_hello_world && cd $_
nano index.js
cat > index.js <<EOF
const functions = require('@google-cloud/functions-framework');

// Register a CloudEvent callback with the Functions Framework that will
// be executed when the Pub/Sub trigger topic receives a message.
functions.cloudEvent('helloPubSub', cloudEvent => {
  // The Pub/Sub message is passed as the CloudEvent's data payload.
  const base64name = cloudEvent.data.message.data;

  const name = base64name
    ? Buffer.from(base64name, 'base64').toString()
    : 'World';

  console.log('Hello,' + name );
});
EOF

cat > package.json <<EOF
{
  "name": "gcf_hello_world",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}
EOF

npm install

echo "Task 2. Deploy the code"
gcloud functions deploy nodejs-pubsub-function \
  --gen2 \
  --runtime=nodejs20 \
  --region=us-east4 \
  --source=. \
  --entry-point=helloPubSub \
  --trigger-topic cf-demo \
  --stage-bucket qwiklabs-gcp-01-cef27dd8961e-bucket \
  --service-account cloudfunctionsa@qwiklabs-gcp-01-cef27dd8961e.iam.gserviceaccount.com \
  --allow-unauthenticated
  
echo "verify the status of the function"
gcloud functions describe nodejs-pubsub-function \
  --region=us-east4 
echo "Task 3. Test the function"
gcloud pubsub topics publish cf-demo --message="Cloud Function Gen2"
echo "Task 4. View logs"
gcloud functions logs read nodejs-pubsub-function \
  --region=us-east4 