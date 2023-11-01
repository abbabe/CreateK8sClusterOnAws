output "master_public_dns" {
  value = aws_instance.master.public_dns
}

output "master_private_dns" {
  value = aws_instance.master.private_dns
}

output "worker1_public_dns" {
  value = aws_instance.worker[0].public_dns
}

output "worker1_private_dns" {
  value = aws_instance.worker[0].private_dns
}

output "worker2_public_dns" {
  value = aws_instance.worker[1].public_dns
}

output "worker2_private_dns" {
  value = aws_instance.worker[1].private_dns
}