#!/bin/sh

set -u
set -e

# Zielverzeichnis (Buildroot übergibt es als $1)
TARGET_DIR=${TARGET_DIR:-$1}

# ============================================================================
# TEIL 1: HDMI Konsole (Bleibt unverändert)
# ============================================================================

if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
    sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
elif [ -d ${TARGET_DIR}/etc/systemd ]; then
    mkdir -p "${TARGET_DIR}/etc/systemd/system/getty.target.wants"
    ln -sf /lib/systemd/system/getty@.service \
        "${TARGET_DIR}/etc/systemd/system/getty.target.wants/getty@tty1.service"
fi

# ============================================================================
# TEIL 2: Firmware Download (Mit deinen Links)
# ============================================================================

echo "Post-build: Start downloading WiFi/BT Firmware for CM5..."

FW_BRCM_DIR="${TARGET_DIR}/lib/firmware/brcm"
mkdir -p "$FW_BRCM_DIR"

# URLs 
# Wir nutzen 'master' statt 'buster', da CM5 sehr neu ist.
# Wir nutzen raw.githubusercontent.com für Stabilität bei wget.
RPI_FW_URL="https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm"

# Deine Regulatory DB Links
REG_DB_URL="https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/plain"

# --- 1. WiFi Firmware (CM5) ---

echo "Downloading WiFi Binary..."
# Original: brcmfmac43455-sdio.bin -> Ziel: brcmfmac43455-sdio.raspberrypi,5-compute-module.bin
if [ ! -f "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.bin" ]; then
    wget -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.bin" \
        "${RPI_FW_URL}/brcmfmac43455-sdio.bin"
fi

echo "Downloading WiFi CLM Blob..."
# Original: brcmfmac43455-sdio.clm_blob -> Ziel: ...clm_blob
if [ ! -f "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob" ]; then
    wget -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob" \
        "${RPI_FW_URL}/brcmfmac43455-sdio.clm_blob"
fi

echo "Downloading WiFi Config TXT..."
# Original: brcmfmac43455-sdio.txt -> Ziel: ...txt
if [ ! -f "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.txt" ]; then
    wget -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.txt" \
        "${RPI_FW_URL}/brcmfmac43455-sdio.txt"
fi

# --- 2. Bluetooth Firmware ---

echo "Downloading Bluetooth HCD..."
# Original: BCM4345C0.hcd -> Ziel: BCM4345C0.raspberrypi,5-compute-module.hcd
if [ ! -f "${FW_BRCM_DIR}/BCM4345C0.raspberrypi,5-compute-module.hcd" ]; then
    wget -O "${FW_BRCM_DIR}/BCM4345C0.raspberrypi,5-compute-module.hcd" \
        "${RPI_FW_URL}/BCM4345C0.hcd"
fi

# --- 3. Regulatory DB  ---

echo "Downloading regulatory.db..."
if [ ! -f "${TARGET_DIR}/lib/firmware/regulatory.db" ]; then
    wget -O "${TARGET_DIR}/lib/firmware/regulatory.db" "${REG_DB_URL}/regulatory.db"
fi

echo "Downloading regulatory.db.p7s..."
if [ ! -f "${TARGET_DIR}/lib/firmware/regulatory.db.p7s" ]; then
    wget -O "${TARGET_DIR}/lib/firmware/regulatory.db.p7s" "${REG_DB_URL}/regulatory.db.p7s"
fi

echo "Post-build: Firmware setup complete."
