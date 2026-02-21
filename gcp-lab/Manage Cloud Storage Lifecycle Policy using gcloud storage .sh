cat << EOF > lifecycle.json
{
    "rule": [
        {
            "action" : {
                "type": "SetStorageClass",
                "storageClass": "Standard"
            },
            "condition": {
                "daysSinceNoncurrentTime": 30,
                "matchesPrefix": ["projects/active/"]
            }
        },
        {
            "action" : {
                "type": "SetStorageClass",
                "storageClass": "NEARLINE"
            },
            "condition": {
                "daysSinceNoncurrentTime": 90,
                "matchesPrefix": ["archive/"]
            }
        },
        {
            "action": {
                "type": "SetStorageClass",
                "storageClass": "COLDLINE"
            },
            "condition": {
                "daysSinceNoncurrentTime": 180,
                "matchesPrefix": ["archive/"]
            }
        },
        {
            "action": {
                "type": "Delete"
            },
            "condition": {
                "matchesPrefix": ["processing/temp_logs/"],
                "age": 7
            }
        }
    ]
}
EOF
BUCKET_NAME=qwiklabs-gcp-03-9669f3d7e9bc-bucket
gcloud storage buckets update gs://$BUCKET_NAME --lifecycle-file=lifecycle.json