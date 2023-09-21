build {
  sources = [
    "source.amazon-ebs.builder",
  ]

  provisioner "ansible" {
    groups        = ["${var.configuration_group}"]
    playbook_file = "${var.playbook_file_path}"
    extra_arguments = [
      "-e", "aws_region=${var.aws_region}",
      "-e", "ansible_shell_type=powershell",
      "-e", "ansible_shell_executable=None",
      "-e", "ansible_user=${build.User}",
      "-e", "ansible_password=${build.Password}",
      "-e", "ansible_connection=winrm",
      "-e", "ansible_winrm_transport=basic",
      "-e", "ansible_winrm_server_cert_validation=ignore",
      "-e", "win2019_base_resolver_update=${var.ansible_resolver_update}",
      "-e", "win2019_base_resolver_adapters=${var.ansible_resolver_adapters}",
      "-e", jsonencode({ "win2019_base_resolver_list" = var.ansible_resolver_list }),
    ]
    use_proxy = false
  }

  provisioner "powershell" {
    inline = [
      # Re-initialise the AWS instance on startup
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/InitializeInstance.ps1 -Schedule *> InitializeInstance.log",
      # Remove system specific information from this image
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SysprepInstance.ps1 -NoShutdown *> SysprepInstance.log"
    ]
  }
}

