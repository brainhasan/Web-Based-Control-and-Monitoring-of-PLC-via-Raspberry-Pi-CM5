#!/bin/sh

set -u
set -e

# Buildroot übergibt den Zielpfad als erstes Argument ($1).
# Falls die Variable TARGET_DIR nicht gesetzt ist, nehmen wir $1.
TARGET_DIR=${TARGET_DIR:-$1}

# ============================================================================
# HDMI Konsole auf tty1
# ============================================================================

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
    sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab

# systemd doesn't use /etc/inittab, enable getty.tty1.service instead
elif [ -d ${TARGET_DIR}/etc/systemd ]; then
    mkdir -p "${TARGET_DIR}/etc/systemd/system/getty.target.wants"
    ln -sf /lib/systemd/system/getty@.service \
        "${TARGET_DIR}/etc/systemd/system/getty.target.wants/getty@tty1.service"
fi


# ============================================================================
# WiFi & Bluetooth Firmware Download für CM5
# ============================================================================

echo "Post-build: Start downloading WiFi/BT Firmware for CM5..."

# Zielverzeichnis erstellen
FW_BRCM_DIR="${TARGET_DIR}/lib/firmware/brcm"
mkdir -p "$FW_BRCM_DIR"

# Basis-URL für RPi-Firmware (Bookworm Branch ist aktuell)
RPI_FW_URL="https://github.com/RPi-Distro/firmware-nonfree/raw/bookworm/brcm"
REG_DB_URL="https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/plain"

# --- 1. WiFi Firmware (CM5 nutzt den Chip BCM43455) ---
# Wir laden die Dateien herunter und benennen sie direkt so, wie das CM5 sie sucht ("raspberrypi,5-compute-module")

if [ ! -f "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.bin" ]; then
    echo "Downloading WiFi Binary..."
    wget -q -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.bin" \
        "${RPI_FW_URL}/brcmfmac43455-sdio.bin"
fi

if [ ! -f "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob" ]; then
    echo "Downloading WiFi CLM Blob..."
    wget -q -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob" \
        "${RPI_FW_URL}/brcmfmac43455-sdio.clm_blob"
fi

if [ ! -f "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.txt" ]; then
    echo "Downloading WiFi Config TXT..."
    wget -q -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.txt" \
        "${RPI_FW_URL}/brcmfmac43455-sdio.txt"
fi

# --- 2. Bluetooth Firmware ---
if [ ! -f "${FW_BRCM_DIR}/BCM4345C0.raspberrypi,5-compute-module.hcd" ]; then
    echo "Downloading Bluetooth HCD..."
    wget -q -O "${FW_BRCM_DIR}/BCM4345C0.raspberrypi,5-compute-module.hcd" \
        "${RPI_FW_URL}/BCM4345C0.hcd"
fi

# --- 3. Regulatory DB (Wichtig für Ländereinstellungen/Kanäle) ---
if [ ! -f "${TARGET_DIR}/lib/firmware/regulatory.db" ]; then
    echo "Downloading regulatory.db..."
    wget -q -O "${TARGET_DIR}/lib/firmware/regulatory.db" "${REG_DB_URL}/regulatory.db"
fi

if [ ! -f "${TARGET_DIR}/lib/firmware/regulatory.db.p7s" ]; then
    echo "Downloading regulatory.db.p7s..."
    wget -q -O "${TARGET_DIR}/lib/firmware/regulatory.db.p7s" "${REG_DB_URL}/regulatory.db.p7s"
fi

echo "Post-build: Firmware setup complete."
