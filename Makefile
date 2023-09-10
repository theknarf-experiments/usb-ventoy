.PHONY: select-device download-ventoy help
.DEFAULT_GOAL := help

ventoy-1.0.95-linux.tar.gz:
	wget -N https://github.com/ventoy/Ventoy/releases/download/v1.0.95/ventoy-1.0.95-linux.tar.gz
	tar zxvf ventoy-1.0.95-linux.tar.gz

download-ventoy: ventoy-1.0.95-linux.tar.gz ## Downloads Ventoy file and extracts the tar file

setup: download-ventoy ## Setup Ventoy on a usb drive
	@selected_device=$$(lsblk -dno NAME,TRAN | awk '/usb/ { print "/dev/" $$1 }' | fzf); \
	if [ -z "$$selected_device" ]; then \
		echo "No device selected!"; \
		exit 1; \
	fi; \
	echo "Selected Device: $$selected_device"; \
	cd ventoy-1.0.95 && ./Ventoy2Disk.sh -i $$selected_device

help:
	@# Help command taken from: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo "Usage: make [task]\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
