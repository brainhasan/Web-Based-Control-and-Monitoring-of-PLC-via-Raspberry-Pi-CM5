# Web-Based Control and Monitoring of PLC via Raspberry Pi CM5

## Project Overview

This project aims to build an **embedded control system** using **Buildroot** on the **Raspberry Pi Compute Module 5 (CM5)**. The system communicates with a **Siemens LOGO! PLC** via **MQTT** and allows users to:

- **Monitor PLC input states** in real time  
- **Control PLC outputs** (turn on/off) from a **web interface** deployed on GitHub  

### Communication Flow

- **PLC ↔ Raspberry Pi CM5**: via MQTT  
- **Website ↔ Raspberry Pi CM5**: via JSON  

The system enables users to remotely monitor and control PLC inputs and outputs using a lightweight embedded Linux system.

### System Architecture

User Browser (HTML)
|
v
JSON commands / state
^
|
Python Backend on CM5
(MQTT client + PLC interface)
^
|
Mosquitto MQTT Broker
^
|
Siemens LOGO! PLC

### Hardware Platform

- **Raspberry Pi Compute Module 5 (CM5)**  
  - Quad-core ARM Cortex-A76 CPU  
  - VideoCore VII GPU  
  - Optional Wi-Fi / Bluetooth  
  - RAM: 4GB or 8GB  
- **Siemens LOGO! PLC**  
- **CM5 Carrier Board** for Ethernet/Wi-Fi and GPIO connections

### Build System

- **Buildroot** to create a lightweight Linux image including:
  - Python 3 and required libraries  
  - Mosquitto MQTT broker  
  - Networking utilities

### Software Components

- **Mosquitto MQTT broker** – PLC ↔ CM5 communication  
- **Python backend** – subscribes to PLC MQTT topics, controls outputs, updates JSON for web interface  
- **HTML/JavaScript frontend** – deployed on GitHub Pages  
- **GitHub Gist (optional)** – JSON storage for PLC state  

### Functionality

- **Read PLC inputs** → Python backend → JSON → web interface  
- **Control PLC outputs** → web interface → JSON → Python backend → MQTT → PLC  
- **Real-time synchronization**: changes from PLC or website are immediately reflected

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
- (Optional) Integrate GitHub Gist JSON storage

### Sprint 3: Web Interface & Deployment
- Develop HTML/JS frontend to display PLC inputs and control outputs  
- Connect frontend to Python backend via JSON API  
- Test full system: PLC ↔ CM5 ↔ Website  
- Deploy frontend on GitHub Pages

---

## Repository Structure

- **Buildroot Repository** – Linux image setup, packages  
- **Backend Repository** – Python scripts for MQTT and PLC interface  
- **Frontend Repository** – HTML/JS web interface  
- Links to repositories to be added after creation

### References

- [Raspberry Pi Compute Module 5](https://www.raspberrypi.com/products/compute-module-5/)  
- [Buildroot Official Documentation](https://buildroot.org/)  
- [Mosquitto MQTT](https://mosquitto.org/)  
- [GitHub Gist API](https://docs.github.com/en/rest/gists)  
- [Python Paho MQTT Library](https://www.eclipse.org/paho/index.php?page=clients/python/index.php)
