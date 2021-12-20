data "template_file" "user_data_file" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    BUCKET       = var.bucket
    CLUSTER_NAME = local.cluster_name
    WORLD        = var.world
  }
}