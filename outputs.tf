output "vpc_id" {
  value = module.vpc.vpc_id
}

output "control_node_public_ip" {
  value = aws_instance.control_node.public_ip
}

output "control_node_private_ip" {
  value = aws_instance.control_node.private_ip
}

output "worker_nodes_private_ips" {
  value = aws_instance.worker_nodes[*].private_ip
}
