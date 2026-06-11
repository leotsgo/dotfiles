#!/bin/bash
# Backup Sealed Secrets keys to S3
# Run after key rotation (every 30 days)

set -e

BACKUP_FILE="/tmp/sealed-secrets-keys-$(date +%Y%m%d-%H%M%S).yaml"
S3_PATH="s3://leotsgo/k3skeys/"

echo "[$(date)] Backing up Sealed Secrets keys..."

# Export all sealed-secrets keys
kubectl get secret -n kube-system \
  -l sealedsecrets.bitnami.com/sealed-secrets-key \
  -o yaml > "$BACKUP_FILE"

# Count keys
KEY_COUNT=$(grep -c "name: sealed-secrets-key" "$BACKUP_FILE" || echo 0)
echo "[$(date)] Found $KEY_COUNT keys"

# Upload to S3
aws s3 cp "$BACKUP_FILE" "$S3_PATH"

# Keep only last 6 backups in S3 (6 months)
aws s3 ls "$S3_PATH" | sort | head -n -6 | awk '{print $4}' | while read old; do
  if [ -n "$old" ]; then
    echo "Removing old backup: $old"
    aws s3 rm "${S3_PATH}${old}"
  fi
done

# Cleanup local
rm -f "$BACKUP_FILE"

echo "[$(date)] Backup complete: ${S3_PATH}$(basename $BACKUP_FILE)"
