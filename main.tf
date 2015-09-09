provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "web" {
  image = "docker"
  name = "web"
  region = "sgp1"
  size = "512mb"
  private_networking = true

  depends_on = [
    "digitalocean_droplet.repo"
  ]

  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/chocolat-team/chocolat.git",
      "docker build -t chocolat ./chocolat",
      "docker run -p 5000:5000 --name web chocolat"
    ]
  }
}

resource "digitalocean_droplet" "repo" {
  image = "docker"
  name = "repo"
  region = "sgp1"
  size = "2gb"
  private_networking = true

  provisioner "remote-exec" {
    inline = [
      "docker run -p 27017:27017 --name mongo mongo"
    ]
  }
}
