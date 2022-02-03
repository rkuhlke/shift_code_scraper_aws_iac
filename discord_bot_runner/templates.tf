data "template_file" "user_data_file" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    CLUSTER_NAME = local.cluster_name
  }
}