output "template" {
  value = data.template_file.user_data_file.rendered
}