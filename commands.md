boundary database init -config /etc/boundary/controller.hcl
boundary server -config /etc/boundary/controller.hcl > /tmp/controller.log 2>&1 &
boundary server -config /etc/boundary/worker.hcl > /tmp/worker.log 2>&1 &
openssl pkey -noout -modulus -in /etc/boundary/cluster.key | openssl md5
openssl x509 -noout -modulus -in /etc/boundary/cluster.crt | openssl md5
openssl rsa  -noout -modulus -in /etc/boundary/cluster.key | openssl md5
