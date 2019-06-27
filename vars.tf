
variable "subnet_block" {
  description = "The subnet to use for each candidate"
  default = "10.0.0.0/24"
}

variable "username" {
  description =  "username for ressources created during practical tests"
  default = "abenyekkou"
}

variable "own_ssh_key" {
  description = "SSH Public key for each candidate"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA05U8AfY746IMuM+YA+mKIpe05F7KQpEwTNpBAuULWY5cCFIxtRGd80EJbdJL5UiEHuq916EPWTjzW43ABAtg18VZyuxRO8TJBnBu+MynB1Ld+nDDNj+kZI+zCAoIgywdRt7f1FI/e6MAMFhLLifVsR/3ZbCUdGXuFnLIle/ulipCLAKKLI/PXdnzigrJHzozyYd4zB5c/sYoEYVOvZ2zvM9pFWF7odagBwaJZE3KTjNsSg5jJJc0m78ga7rQqUgFVgv1GRh99rslE2XzOmzKhdqhQfsAiQUkjHASH7WvPgsl9GFz5tT0j5bkVSwLHK070U8W1l+uJx0kEF18FUqN amir@MacBook-Pro-de-Amir.local"
}

variable "own_ssh_key_path" {
  description = "Path of public key for each candidate"
  default = "/Users/amir/.ssh/id_rsa"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 80
}
