resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/inventory.tmpl",
    {
      ip_addrs = aws_instance.worker_nodes.*.private_ip
    }
  )
  filename = "inventory"
}