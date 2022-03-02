locals {
  images_domain = "images.${terraform.workspace}.${var.domain}"
  blog_domain = "${terraform.workspace}.${var.domain}"
}
