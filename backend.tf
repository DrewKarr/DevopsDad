terraform {
  backend "gcs" {
    bucket      = "doc-drew-20220304174003"
    prefix      = "terraform/state"
    credentials = "account.json"
  }
}
