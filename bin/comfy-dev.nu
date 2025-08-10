#!/usr/bin/env nu

def main [
  --dev (-d)  # Develop plugin
  --test (-t) # Test Comfyui
] {
	if $dev {
		sudo chmod -R 0774 /var/lib/comfyui/custom_nodes/ConditionalOps; print "Ready to dev"
	}

	if $test {
		sudo chmod -R 0754 /var/lib/comfyui/custom_nodes/ConditionalOps; print "Ready to dev"
	  sudo podman restart comfyui; print "Ready to test"
	}
}
