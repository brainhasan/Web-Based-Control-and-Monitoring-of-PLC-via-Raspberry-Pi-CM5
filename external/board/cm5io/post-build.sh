#!/bin/sh

set -u
set -e

# Zielverzeichnis
TARGET_DIR=${TARGET_DIR:-$1}

# ============================================================================
# TEIL 1: HDMI Konsole
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
# TEIL 2: Firmware Download (WiFi/BT für CM5)
# ============================================================================
echo "Post-build: Start downloading WiFi/BT Firmware for CM5..."

FW_BRCM_DIR="${TARGET_DIR}/lib/firmware/brcm"
mkdir -p "$FW_BRCM_DIR"

RPI_WIFI_URL="https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm"
RPI_BT_URL="https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/master/broadcom"
REG_DB_URL="https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/plain"

# WiFi
wget -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.bin" "${RPI_WIFI_URL}/brcmfmac43455-sdio.bin"
wget -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob" "${RPI_WIFI_URL}/brcmfmac43455-sdio.clm_blob"
wget -O "${FW_BRCM_DIR}/brcmfmac43455-sdio.raspberrypi,5-compute-module.txt" "${RPI_WIFI_URL}/brcmfmac43455-sdio.txt"

# Bluetooth
wget -O "${FW_BRCM_DIR}/BCM4345C0.raspberrypi,5-compute-module.hcd" "${RPI_BT_URL}/BCM4345C0.hcd"

# Regulatory DB
wget -O "${TARGET_DIR}/lib/firmware/regulatory.db" "${REG_DB_URL}/regulatory.db"
wget -O "${TARGET_DIR}/lib/firmware/regulatory.db.p7s" "${REG_DB_URL}/regulatory.db.p7s"

# ============================================================================
# TEIL 3: TLS/SSL Zertifikate für HiveMQ Cloud (NEU)
# ============================================================================
echo "Post-build: Downloading HiveMQ/Let's Encrypt CA certificates..."

CERT_DIR="${TARGET_DIR}/etc/ssl/certs"
mkdir -p "$CERT_DIR"

# ISRG Root X1 Zertifikat für HiveMQ Cloud
HIVEMQ_CA_URL="https://letsencrypt.org/certs/isrgrootx1.pem.txt"

if [ ! -f "${CERT_DIR}/isrgrootx1.pem" ]; then
    wget -O "${CERT_DIR}/isrgrootx1.pem" "$HIVEMQ_CA_URL"
    # Optional: Ein Symlink, damit Python/OpenSSL es im Standard-Pfad findet
    ln -sf isrgrootx1.pem "${CERT_DIR}/ca-certificates.crt"
fi

echo "Post-build: Firmware and SSL setup complete."
