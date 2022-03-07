terraform {
  backend "gcs" {
    bucket      = "drewlearns-123456789"
    prefix      = "terraform/state"
    credentials = "account.json"
  }
}
