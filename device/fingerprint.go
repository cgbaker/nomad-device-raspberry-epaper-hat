package device

import (
	"context"
	"time"

	"github.com/hashicorp/nomad/helper/uuid"
	"github.com/hashicorp/nomad/plugins/device"
)

// doFingerprint is the long-running goroutine that detects device changes
func (d *SkeletonDevicePlugin) doFingerprint(ctx context.Context, devices chan *device.FingerprintResponse) {
	defer close(devices)

	// Create a timer that will fire immediately for the first detection
	ticker := time.NewTimer(0)

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			ticker.Reset(30*time.Second)
		}

		d.writeFingerprintToChannel(devices)
	}
}


var (
	ID = uuid.Generate()
)

// writeFingerprintToChannel collects fingerprint info, partitions devices into
// device groups, and sends the data over the provided channel.
func (d *SkeletonDevicePlugin) writeFingerprintToChannel(devices chan<- *device.FingerprintResponse) {
	deviceGroups := []*device.DeviceGroup{
		{
			Vendor:     "adafruit",
			Type:       "epaper",
			Name:       "papirus",
			Devices:    []*device.Device{
				{
					ID:         ID,
					Healthy:    true,
					HealthDesc: "",
					HwLocality: nil,
				},
			},
			Attributes: nil,
		},
	}
	devices <- device.NewFingerprint(deviceGroups...)
}

