# USB Ventoy

Setup of a USB with Ventoy and a bunch of useful tools.

## Setup ventoy

1. Install `fzf`, `wget`, `tar` and `make` on Linux

```
sudo apt-get install -y fzf wget tar make
```

2. Insert the USB drive

3. Run `sudo make setup`, select the drive from the list and let it install

## Download iso's

Run:

```
make download-iso
```

This will use `wget` to download several iso's

Then insert the usb Ventoy drive and run:

```
make sync-to-ventoy
```
