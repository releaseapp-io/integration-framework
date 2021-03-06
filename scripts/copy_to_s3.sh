#!/bin/bash
export REV=$(git rev-parse HEAD | cut -c1-8)
python -c 'import glob, json, os; print json.dumps({"sha": os.environ["REV"], "integrations": [dir.split("/")[1] for dir in glob.glob("**/*/manifest.json")]})' > latest
aws s3 cp --recursive integrations s3://$BUCKET_NAME/integrations/$REV
aws s3 cp --recursive --exclude "*" --include "*.svg" integrations s3://launchdarkly-static/integrations/$REV
aws s3 cp manifest.schema.json s3://$BUCKET_NAME/integrations/$REV/manifest.schema.json --metadata-directive REPLACE --content-type "application/json"
aws s3 cp latest s3://$BUCKET_NAME/latest.json --metadata-directive REPLACE --content-type "application/json"
