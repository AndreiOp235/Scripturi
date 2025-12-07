# Script Collection

## Overview  
This repository contains various scripts for different use cases, including serial monitoring, HTTP file hosting, and network security-related tasks. Use these scripts responsibly and ensure compliance with legal and ethical guidelines before running them.  

## Scripts  

### 1. **Serial Monitor (`serialMonitor.py`)**  
A Python script to monitor data from a serial port (e.g., an Arduino).  

#### Usage:  
- Configure the `port` and `baud_rate` variables to match your device.  
- Run the script to display real-time serial data.  
- Press `Ctrl+C` to exit safely.  

#### Dependencies:  
- `pyserial` (`pip install pyserial`)  

---

### 2. **HTTP File Server (`httpServer.py`)**  
A simple Flask-based HTTP server for serving files from a directory.  

#### Usage:  
- Change the `DIRECTORY` variable to the folder you want to share.  
- Run the script to start the server.  
- Access the files via a web browser using the displayed IP address.  

#### Dependencies:  
- `Flask` (`pip install flask`)  

---

### 3. **WiFi Cracking Scripts (`crack.sh`, `crackWifiTemplate.sh`)**  
These scripts use `aircrack-ng` to perform WiFi network security testing.  

#### ⚠ **Disclaimer:**  
- These scripts are for educational and authorized penetration testing only.  
- Ensure you have permission before using them on any network.  

#### Usage:  
- Requires a wireless adapter in monitor mode.  
- Run with `sudo` to capture and analyze WiFi packets.  

#### Dependencies:  
- `aircrack-ng` package (`sudo apt install aircrack-ng`)  

---

### 4. **PowerShell Scripts (`empty.ps1`, `pow2.ps1`, `powha.ps1`)**  
- empthy will recursively delete all empthy folder inside a given target
- pow2 and powha will search for archieves inside a target and unpack them
- these scripts were used for sorting a large ammount of materials for university from questionable sources


---

## Requirements  
- Python 3+ (for Python scripts)  
- PowerShell (for `.ps1` scripts)  
- Linux with `aircrack-ng` (for cracking scripts)  

---

## Legal Notice  
Unauthorized use of security-related scripts can lead to legal consequences. Only use them for ethical hacking, penetration testing, or educational purposes with explicit permission.  

---

## Contact  
For questions or improvements, feel free to contribute or contact the repository maintainer.
