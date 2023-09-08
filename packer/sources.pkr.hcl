source "amazon-ebs" "builder" {
  ami_name              = "${var.ami_name_prefix}-${var.version}"
  ami_users             = var.ami_account_ids
  force_delete_snapshot = var.force_delete_snapshot
  force_deregister      = var.force_deregister
  instance_type         = var.aws_instance_type
  region                = var.aws_region
  ssh_private_key_file  = var.ssh_private_key_file
  ssh_keypair_name      = "packer-builders-${var.aws_region}"
  iam_instance_profile  = "packer-builders-${var.aws_region}"
  encrypt_boot          = var.encrypt_boot
  kms_key_id            = var.kms_key_id

  communicator         = "winrm"
  winrm_insecure       = var.winrm_insecure
  winrm_username       = var.winrm_username
  winrm_use_ssl        = var.winrm_use_ssl
  user_data_file       = "${var.powershell_path}/winrm_bootstrap.txt"

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = var.root_volume_size_gb
    volume_type = "gp2"
    delete_on_termination = true
  }

  security_group_filter {
    filters = {
      "group-name": "packer-builders-${var.aws_region}"
    }
  }

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name =  "${var.aws_source_ami_filter_name}"
      root-device-type = "ebs"
    }
    owners = ["${var.aws_source_ami_owner_id}"]
    most_recent = true
  }

  subnet_filter {
    filters = {
      "tag:Name": "${var.aws_subnet_filter_name}"
    }
    most_free = true
    random = false
  }

  run_tags = {
    AMI     = "${var.ami_name_prefix}"
    Service = "packer-builder"
  }

  tags = {
    Name    = "${var.ami_name_prefix}-${var.version}"
  }
}
