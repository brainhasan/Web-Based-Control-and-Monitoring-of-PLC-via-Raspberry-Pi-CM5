# Lightweight Industrial SCADA System Using Buildroot on Raspberry Pi CM5 and PLC

## Project Overview

This project aims to build an **embedded control system** using **Buildroot** on the **Raspberry Pi Compute Module 5 (CM5)**. The system communicates with a **Siemens LOGO! PLC** via **MQTT** and allows the user to:

- **Monitor PLC input states** in real time  
- **Control PLC outputs (turn on/off)** from a web interface using MQTT over HiveMQ 

### Communication Flow

- **PLC ↔ Raspberry Pi CM5** : via MQTT (Local Broker / Ethernet)
- **Raspberry Pi CM5 ↔ HiveMQ**: via MQTT (Wi-Fi)
- **Website ↔ HiveMQ: via MQTT** over WebSockets

The system enables users to remotely monitor and control PLC inputs and outputs using a lightweight embedded Linux system.

### System Architecture

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/45ab72cd-02b6-426a-a1e7-308bcde430eb" />

### Hardware Platform

- **Raspberry Pi Compute Module 5 (CM5)**  
  - Quad-core ARM Cortex-A76 CPU  
  - VideoCore VII GPU  
  - Optional Wi-Fi / Bluetooth  
  - RAM: 4GB or 8GB  
- **Siemens LOGO! PLC**  
- **CM5 Carrier Board** for Ethernet/Wi-Fi and GPIO connections  
- **Buildroot Support**: Cross-compilation with custom Linux image including Python, networking, and MQTT packages  

### Build System

- **Buildroot** to create a lightweight Linux image including:
  - Python 3 and required libraries  
  - Mosquitto MQTT broker  
  - Networking utilities
  - Wi-Fi drivers and required binary firmware  

### Software Components

- **Mosquitto MQTT broker** – PLC ↔ CM5 communication  
- **Python backend** – subscribes to MQTT topics, controls outputs, bridges local and cloud brokers
- **HTML/JavaScript frontend** – uses MQTT over WebSockets via HiveMQ
- **HiveMQ Cloud MQTT Broker** – online communication

### Packages and Open Source Projects  

- **Paho-MQTT – Python MQTT client**
- **HiveMQ MQTT** services 
- **HTML / CSS** – frontend web interface  
- **GitHub Gist API** – to send real-time updates of PLC states  

### Previous Assignment Content

- **Buildroot setup** – cross-compiling Linux images for Raspberry Pi  
- **Running an application on startup** – using init scripts or systemd  

### New Content Beyond Course

- Use **Python as backend** to communicate with PLC and MQTT  
- Connect the embedded system to the network for web access  
- Use **MQTT** for communication between CM5 and PLC  
- Run **MQTT broker** on the system to enable real-time input/output updates
- Use of dual MQTT broker architecture (local + cloud) Integration of HiveMQ Cloud


### Functionality

- **Read PLC inputs** → Local MQTT → Python backend → HiveMQ → Web interface
- **Control PLC outputs** → Web interface → HiveMQ → Python backend → Local MQTT → PLC


### Repository Structure and Organization

Single repository used for:

Buildroot configuration

Python backend

Web frontend

ocumentation & Wiki

### Team Members & Roles
Hasan Edrees — Sole developer responsible for Buildroot image, backend MQTT integration, and web interface implementation

---

## Implementation Plan

### Sprint 1: Buildroot & MQTT Setup
- Configure Buildroot for CM5 with Python3 and networking utilities  
- Cross-compile Linux image and deploy on CM5  
- Install Mosquitto MQTT broker  
- Test MQTT communication between CM5 and PLC

### Sprint 2: Python Backend & PLC Integration
- Implement Python scripts to read PLC inputs via MQTT  
- Implement Python scripts to control PLC outputs  
- Test end-to-end communication with PLC  
- Configure bridge between local broker and HiveMQ

### Sprint 3: Web Interface & Deployment
- Develop HTML/JS frontend to display PLC inputs and control outputs  
- Connect frontend to HiveMQ using MQTT over WebSockets
- Test full system: PLC ↔ CM5 ↔ Website  
- Deploy frontend on GitHub Pages

---


## Repository Structure

- **Buildroot Repository** – Linux image setup, packages  
- **Backend Repository** – Python scripts for MQTT and PLC interface  
- **Frontend Repository** – HTML/JS web interface  
- Links to repositories to be added after creation

## Repository Structure and Organization

Single repository used for:

Buildroot configuration

Python backend

Web frontend

## Documentation & Wiki
Team Members & Roles
Hasan Edrees — Sole developer responsible for Buildroot image, backend MQTT integration, and web interface implementation
---

## References

- [Raspberry Pi Compute Module 5](https://www.raspberrypi.com/products/compute-module-5/)  
- [Buildroot Official Documentation](https://buildroot.org/)  
- [Mosquitto MQTT](https://mosquitto.org/)  
- [GitHub Gist API](https://docs.github.com/en/rest/gists)  
- [Python Paho MQTT Library](https://www.eclipse.org/paho/index.php?page=clients/python/index.php)
  
## Schedule Page
  https://github.com/users/brainhasan/projects/2/views/1?visibleFields=%5B%22Title%22%2C%22Assignees%22%2C%22Status%22%2C255968077%5D
