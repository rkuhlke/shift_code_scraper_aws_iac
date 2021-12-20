locals {
  cluster_name = format("%s-%s-%s-ecs-cluster", var.project, var.environment, var.application)
}