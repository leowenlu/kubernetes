helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=leoonline.net \
  --set global.hosts.externalIP=10.10.10.10 \
  --set certmanager-issuer.email=me@leoonline.net\
  --set postgresql.image.tag=13.6.0