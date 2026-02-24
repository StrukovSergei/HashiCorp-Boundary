disable_mlock = true

worker {
  name = "boundary-worker"
  description = "POC worker"
  controllers = ["127.0.0.1:9201"]

  public_addr = "INSERTIPHERE"
}

listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
kms "aead" {

  purpose = "worker-auth"

  aead_type = "aes-gcm"

  key = "MDEyMzQ1Njc4OWFiY2RexampleM0NTY3ODlhYmNkZWY="

}
