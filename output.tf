output "boundary_target_name" {
  value = boundary_target.target.name
}

output "boundary_target_id" {
  value = boundary_target.target.id
}

output "Instructions_Boundary_Desktop" {
    value = "To access the VM, open Boundary Desktop and connect to the target id/name"
}

output "Instructions_Boundary_CLI" {
    value = "boundary connect ssh -target-id=${boundary_target.target.id}"
}