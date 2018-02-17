variable "do_token" {}
variable "do_ssh_id" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "destalinator" {
  image = "ubuntu-16-04-x64"
  name = "destalinator"
  region = "nyc3"
  size = "1gb"
  backups = "false"
  monitoring = "false"
  ipv6 = "false"
  private_networking = "false"
  ssh_keys = ["${var.do_ssh_id}"]
  resize_disk = "true"
  tags = []
  user_data = "#!/bin/bash\n/usr/bin/apt-get -y install python"
  volume_ids = []
}

resource "digitalocean_firewall" "destalinator" {
  name = "destalinator"
  droplet_ids = ["${digitalocean_droplet.destalinator.id}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0"]
    }
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0"]
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0"]
    }
  ]
}

resource "digitalocean_floating_ip" "destalinator" {
  droplet_id = "${digitalocean_droplet.destalinator.id}"
  region     = "${digitalocean_droplet.destalinator.region}"
}
