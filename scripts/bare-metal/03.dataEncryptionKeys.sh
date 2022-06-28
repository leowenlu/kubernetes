ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

# copy the encryption config over to master nodes
for instance in master-1 master-2
  do
    scp encryption-config.yaml ${instance}:~/
    ssh ${instance} sudo mkdir -p /var/lib/kubernetes/
    ssh ${instance} sudo cp encryption-config.yaml /var/lib/kubernetes/
  done
