build {
  sources = [
    "source.amazon-ebs.builder",
  ]

  provisioner "powershell" {
    inline = [
      # Re-initialise the AWS instance on startup
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/InitializeInstance.ps1 -Schedule *> InitializeInstance.log",
      # Remove system specific information from this image
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SysprepInstance.ps1 -NoShutdown *> SysprepInstance.log"
    ]
  }
}
