job "device-demo" {
  datacenters = ["dc1"]
  type = "batch"
  group "demo" {
    task "demo" {

      driver = "exec"
      config {
        command = "papirus-draw"
        args = ["nomad.gif"]
      }

      artifact {
        source = "https://github.com/cgbaker/nomad-device-raspberry-epaper-hat/raw/master/examples/nomad.gif"
        destination = "local/nomad.gif"
      }

      resources {
        cpu = 64
        memory = 64
        device "epaper" {}
      }
     
    }
  }
}
