.PHONY: select-device download-ventoy help sync-to-ventoy
.DEFAULT_GOAL := help

isos = \
	iso/netboot.xyz-multiarch.iso \
	iso/batocera-x86_64-37-20230617.img.gz \
	iso/proxmox-ve_8.0-2.iso

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

iso/netboot.xyz-multiarch.iso:
	@mkdir -p iso
	cd iso && wget -N --inet4-only https://boot.netboot.xyz/ipxe/netboot.xyz-multiarch.iso

iso/batocera-x86_64-37-20230617.img.gz:
	@mkdir -p iso
	cd iso && wget -N https://updates.batocera.org/x86_64/stable/last/batocera-x86_64-37-20230617.img.gz

iso/proxmox-ve_8.0-2.iso:
	@mkdir -p iso
	cd iso && wget -N --inet4-only https://enterprise.proxmox.com/iso/proxmox-ve_8.0-2.iso

download-iso: $(isos) ## Downloads iso's to put onto the Ventoy drive

sync-to-ventoy: ## Sync content of iso folder onto the Ventoy drive
	@mkdir -p iso
	@VENTOY_PATH=$$(mount | grep Ventoy | awk '{print $$3}') ; \
	if [ -z "$$VENTOY_PATH" ]; then \
		echo "Ventoy drive not found"; \
		exit 1; \
	else \
		rsync -avu --progress iso/ $$VENTOY_PATH/ ; \
	fi

help:
	@# Help command taken from: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo "Usage: make [task]\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
