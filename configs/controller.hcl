disable_mlock = true

controller {
  name = "boundary-controller"
  description = "POC controller"
  database {
    url = "postgresql://boundary:INSERTPASSHERE@127.0.0.1:5432/boundary?sslmode=disable"
  }
}

listener "tcp" {
  address = "0.0.0.0:9200"
  purpose = "api"
  tls_disable = true
}

listener "tcp" {
  address        = "0.0.0.0:9201"
  purpose        = "cluster"
  tls_disable    = false
  tls_cert_file  = "/etc/boundary/cluster.crt"
  tls_key_file   = "/etc/boundary/cluster.key"
}

kms "aead" {
  purpose   = "root"
  aead_type = "aes-gcm"
  key       = "0123456789example123456789abcdef"
}

kms "aead" {
  purpose   = "worker-auth"
  aead_type = "aes-gcm"
  key       = "MDEyMzQ1Njc4OexampleZjAxMjM0NTY3ODlhYmNkZWY="
}

kms "aead" {
  purpose   = "recovery"
  aead_type = "aes-gcm"
  key       = "fedcba9876543210example876543210"
}
