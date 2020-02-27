job "device-demo" {
  datacenters = ["dc1"]
  type = "batch"
  group "demo" {
    task "demo" {

      driver = "python"
      config {
        script = "drawer.py"
      }

      template {
        destination = "drawer.py"
        data = <<EOF
import sys                                    # import sys
sys.path.insert(1, "./lib")                   # add the lib folder to sys so python can find the libraries

import epd2in7b                               # import the display drivers
from PIL import Image,ImageDraw
import time                                      

epd = epd2in7b.EPD()                          # get the display object and assing to epd
epd.init()                                    # initialize the display
print("Clear...")                             # print message to console (not display) for debugging
epd.Clear(0xFF)                               # clear the display

red = Image.new('1', (epd2in7b.EPD_HEIGHT, epd2in7b.EPD_WIDTH), 255)  # 298*126
im = Image.open("image.png")
draw = ImageDraw.Draw(im)
epd.display(epd.getbuffer(HBlackImage), epd.getbuffer(HRedImage))
EOF
      }

      resources {
        cpu = 64
        memory = 64
        device "epaper" {}
      }
     
    }
  }
}
