# WiFi Network Scanner

A Python script that scans for available WiFi networks and retrieves passwords for saved networks on your system.

## Features

- 🔍 Scans for all available WiFi networks in range
- 🔑 Retrieves passwords for networks you've previously connected to
- 💻 Cross-platform support (Windows, Linux, macOS)
- 🛡️ Ethical design - only accesses networks you own or have permission to use

## Requirements

- Python 3.6 or higher
- Platform-specific tools:
  - **Windows**: Built-in `netsh` command (no additional installation needed)
  - **Linux**: NetworkManager (`nmcli`) or `iwlist` (usually pre-installed)
  - **macOS**: Built-in `networksetup` and `security` commands

## Installation

1. Clone this repository or download the `wifi_scanner.py` script
2. No additional Python packages required - uses only standard library

## Usage

### Windows

Run the script with administrator privileges:

```bash
python wifi_scanner.py
```

Or right-click on the script and select "Run as administrator"

### Linux

Run with sudo for full functionality:

```bash
sudo python3 wifi_scanner.py
```

Note: Without sudo, you may only be able to scan networks but not retrieve passwords.

### macOS

Simply run the script:

```bash
python3 wifi_scanner.py
```

You may be prompted to grant keychain access when retrieving passwords.

## How It Works

1. **Network Scanning**: The script uses system commands to scan for available WiFi networks:
   - Windows: `netsh wlan show networks`
   - Linux: `nmcli dev wifi` or `iwlist scan`
   - macOS: `airport -s`

2. **Password Retrieval**: Passwords are retrieved only for networks already saved on your system:
   - Windows: `netsh wlan show profile <name> key=clear`
   - Linux: `nmcli connection show <name>` (requires sudo)
   - macOS: `security find-generic-password` (may require keychain access)

## Important Notes

### Security & Ethics

⚠️ **This script only retrieves passwords for WiFi networks that are already saved on your computer.** 

- It does NOT hack or crack WiFi passwords
- It does NOT access networks you haven't connected to before
- It only shows passwords you've previously entered on this device
- Use responsibly and only on networks you own or have permission to access

### Permissions

- **Windows**: Requires administrator privileges
- **Linux**: Requires sudo for password retrieval
- **macOS**: May require keychain access approval

### Limitations

- Cannot retrieve passwords for networks you've never connected to
- Cannot crack WPA/WPA2 encryption
- Only works for networks saved on the current device
- Some corporate/enterprise networks may not show passwords due to security policies

## Output Example

```
==============================================================
WiFi Network Scanner
==============================================================

📡 Available WiFi Networks:
--------------------------------------------------------------
1. HomeNetwork_5G
2. OfficeWiFi
3. CoffeeShop_Guest
4. Neighbor_Network

🔑 Saved Network Passwords:
--------------------------------------------------------------

Network: HomeNetwork_5G
Password: MySecurePassword123

Network: OfficeWiFi
Password: CompanyWiFi2024

==============================================================
```

## Troubleshooting

### Linux: "nmcli not found"

Install NetworkManager:
```bash
sudo apt-get install network-manager  # Debian/Ubuntu
sudo yum install NetworkManager        # RHEL/CentOS
```

### macOS: "Keychain access denied"

When prompted, click "Allow" to grant the script access to your keychain.

### Windows: "Access denied"

Make sure to run the script as administrator (right-click → "Run as administrator").

## License

This script is provided for educational and legitimate system administration purposes only.

## Disclaimer

This tool is intended for legitimate use only:
- Recovering your own WiFi passwords
- System administration on networks you manage
- Educational purposes

Unauthorized access to computer networks is illegal. Always obtain proper authorization before accessing any network.
