#!/usr/bin/env python3
"""
WiFi Network Scanner
This script scans for available WiFi networks and retrieves passwords for saved networks.
Note: This only works for networks that are already saved on your system.
"""

import subprocess
import platform
import re
import sys
import os
import shutil


class WiFiScanner:
    def __init__(self):
        self.system = platform.system()
        
    def scan_available_networks(self):
        """Scan for available WiFi networks"""
        print("\n" + "="*60)
        print("Scanning for available WiFi networks...")
        print("="*60 + "\n")
        
        try:
            if self.system == "Windows":
                return self._scan_windows()
            elif self.system == "Linux":
                return self._scan_linux()
            elif self.system == "Darwin":  # macOS
                return self._scan_macos()
            else:
                print(f"Unsupported operating system: {self.system}")
                return []
        except Exception as e:
            print(f"Error scanning networks: {e}")
            return []
    
    def _scan_windows(self):
        """Scan WiFi networks on Windows"""
        try:
            # Get list of available networks
            result = subprocess.run(
                ["netsh", "wlan", "show", "networks"],
                capture_output=True,
                text=True,
                check=True
            )
            
            networks = []
            lines = result.stdout.split('\n')
            
            for line in lines:
                if "SSID" in line and "BSSID" not in line:
                    ssid = line.split(":", 1)[1].strip()
                    if ssid:
                        networks.append(ssid)
            
            return networks
        except subprocess.CalledProcessError as e:
            print(f"Error scanning networks on Windows: {e}")
            return []
    
    def _scan_linux(self):
        """Scan WiFi networks on Linux"""
        try:
            # Try using nmcli (NetworkManager)
            result = subprocess.run(
                ["nmcli", "-t", "-f", "SSID", "dev", "wifi"],
                capture_output=True,
                text=True,
                check=True
            )
            
            networks = [ssid.strip() for ssid in result.stdout.split('\n') if ssid.strip()]
            return networks
        except (subprocess.CalledProcessError, FileNotFoundError):
            # Fallback to iwlist (note: user should run script with sudo if nmcli unavailable)
            try:
                # Try to find wireless interface
                interface = self._get_wireless_interface_linux()
                if not interface:
                    print("Error: No wireless interface found")
                    return []
                
                # Check if running with sufficient privileges
                if os.geteuid() != 0:
                    print("Note: For iwlist scanning, please run this script with sudo")
                    return []
                
                result = subprocess.run(
                    ["iwlist", interface, "scan"],
                    capture_output=True,
                    text=True,
                    check=True
                )
                
                networks = []
                for line in result.stdout.split('\n'):
                    if 'ESSID:' in line:
                        match = re.search(r'ESSID:"(.+)"', line)
                        if match:
                            networks.append(match.group(1))
                
                return networks
            except Exception as e:
                print(f"Error scanning networks on Linux: {e}")
                print("You may need to install NetworkManager (nmcli) or run with sudo for iwlist")
                return []
    
    def _get_wireless_interface_linux(self):
        """Get the first available wireless interface on Linux"""
        try:
            result = subprocess.run(
                ["iw", "dev"],
                capture_output=True,
                text=True,
                check=True
            )
            
            for line in result.stdout.split('\n'):
                if 'Interface' in line:
                    interface = line.split()[1]
                    return interface
        except:
            # Fallback to common interface names
            common_interfaces = ['wlan0', 'wlp2s0', 'wlp3s0', 'wlo1']
            for iface in common_interfaces:
                if os.path.exists(f'/sys/class/net/{iface}'):
                    return iface
        
        return None
    
    def _scan_macos(self):
        """Scan WiFi networks on macOS"""
        try:
            # Try to find the airport utility
            airport_path = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
            
            # Check if airport exists at the expected path
            if not os.path.exists(airport_path):
                # Try alternative path or use which to find it
                which_result = shutil.which("airport")
                if which_result:
                    airport_path = which_result
                else:
                    print("Error: airport utility not found on this macOS system")
                    return []
            
            result = subprocess.run(
                [airport_path, "-s"],
                capture_output=True,
                text=True,
                check=True
            )
            
            networks = []
            lines = result.stdout.split('\n')[1:]  # Skip header
            
            for line in lines:
                if line.strip():
                    parts = line.split()
                    if parts:
                        networks.append(parts[0])
            
            return networks
        except Exception as e:
            print(f"Error scanning networks on macOS: {e}")
            return []
    
    def get_saved_passwords(self):
        """Get passwords for saved WiFi networks"""
        print("\n" + "="*60)
        print("Retrieving passwords for saved networks...")
        print("="*60 + "\n")
        
        try:
            if self.system == "Windows":
                return self._get_passwords_windows()
            elif self.system == "Linux":
                return self._get_passwords_linux()
            elif self.system == "Darwin":
                return self._get_passwords_macos()
            else:
                print(f"Unsupported operating system: {self.system}")
                return {}
        except Exception as e:
            print(f"Error retrieving passwords: {e}")
            return {}
    
    def _get_passwords_windows(self):
        """Get saved WiFi passwords on Windows"""
        passwords = {}
        
        try:
            # Get list of saved profiles
            result = subprocess.run(
                ["netsh", "wlan", "show", "profiles"],
                capture_output=True,
                text=True,
                check=True
            )
            
            profiles = []
            for line in result.stdout.split('\n'):
                if "All User Profile" in line:
                    profile = line.split(":", 1)[1].strip()
                    profiles.append(profile)
            
            # Get password for each profile
            for profile in profiles:
                try:
                    # Validate profile name to prevent command injection
                    # Only allow alphanumeric, spaces, hyphens, and underscores
                    if not re.match(r'^[\w\s\-]+$', profile):
                        passwords[profile] = "Invalid profile name (security check)"
                        continue
                    
                    result = subprocess.run(
                        ["netsh", "wlan", "show", "profile", profile, "key=clear"],
                        capture_output=True,
                        text=True,
                        check=True
                    )
                    
                    for line in result.stdout.split('\n'):
                        if "Key Content" in line:
                            password = line.split(":", 1)[1].strip()
                            passwords[profile] = password
                            break
                    else:
                        passwords[profile] = "No password or unavailable"
                        
                except subprocess.CalledProcessError:
                    passwords[profile] = "Error retrieving password"
            
            return passwords
            
        except subprocess.CalledProcessError as e:
            print(f"Error retrieving passwords on Windows: {e}")
            return {}
    
    def _get_passwords_linux(self):
        """Get saved WiFi passwords on Linux"""
        passwords = {}
        
        # Check if running with sufficient privileges
        if os.geteuid() != 0:
            print("Note: Root/sudo access required to retrieve WiFi passwords on Linux")
            print("Please run this script with: sudo python3 wifi_scanner.py")
            return {}
        
        try:
            # Try using nmcli
            result = subprocess.run(
                ["nmcli", "-t", "-f", "NAME", "connection", "show"],
                capture_output=True,
                text=True,
                check=True
            )
            
            connections = [conn.strip() for conn in result.stdout.split('\n') if conn.strip()]
            
            for conn in connections:
                try:
                    # Validate connection name to prevent command injection
                    if not conn or len(conn) > 200:  # Reasonable limit
                        continue
                    
                    result = subprocess.run(
                        ["nmcli", "-s", "-g", "802-11-wireless-security.psk", "connection", "show", conn],
                        capture_output=True,
                        text=True,
                        check=True
                    )
                    
                    password = result.stdout.strip()
                    if password:
                        passwords[conn] = password
                    else:
                        passwords[conn] = "No password or open network"
                        
                except subprocess.CalledProcessError:
                    passwords[conn] = "Error retrieving password"
            
            return passwords
            
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("Error: NetworkManager (nmcli) not found or insufficient permissions")
            return {}
    
    def _get_passwords_macos(self):
        """Get saved WiFi passwords on macOS"""
        passwords = {}
        
        try:
            # Get list of preferred networks
            result = subprocess.run(
                ["networksetup", "-listpreferredwirelessnetworks", "en0"],
                capture_output=True,
                text=True,
                check=True
            )
            
            networks = []
            for line in result.stdout.split('\n')[1:]:  # Skip header
                network = line.strip()
                if network:
                    networks.append(network)
            
            # Get password for each network
            for network in networks:
                try:
                    # Validate network name to prevent command injection
                    if not network or len(network) > 200:  # Reasonable limit
                        continue
                    
                    result = subprocess.run(
                        ["security", "find-generic-password", "-wa", network],
                        capture_output=True,
                        text=True,
                        check=True
                    )
                    
                    password = result.stdout.strip()
                    passwords[network] = password if password else "No password found"
                    
                except subprocess.CalledProcessError:
                    passwords[network] = "Error retrieving password (may need keychain access)"
            
            return passwords
            
        except subprocess.CalledProcessError as e:
            print(f"Error retrieving passwords on macOS: {e}")
            return {}
    
    def display_results(self, available_networks, saved_passwords):
        """Display the scan results"""
        print("\n" + "="*60)
        print("SCAN RESULTS")
        print("="*60)
        
        # Display available networks
        print("\n📡 Available WiFi Networks:")
        print("-" * 60)
        if available_networks:
            for i, network in enumerate(available_networks, 1):
                print(f"{i}. {network}")
        else:
            print("No networks found")
        
        # Display saved passwords
        print("\n🔑 Saved Network Passwords:")
        print("-" * 60)
        if saved_passwords:
            for network, password in saved_passwords.items():
                print(f"\nNetwork: {network}")
                print(f"Password: {password}")
        else:
            print("No saved passwords found")
        
        print("\n" + "="*60)


def main():
    """Main function"""
    print("\n" + "="*60)
    print("WiFi Network Scanner")
    print("="*60)
    print("\nThis script will:")
    print("1. Scan for available WiFi networks")
    print("2. Retrieve passwords for networks saved on your system")
    print("\nNote: You can only retrieve passwords for networks you")
    print("have previously connected to on this device.")
    
    # Check for admin/root privileges on certain systems
    system = platform.system()
    if system == "Linux":
        print("\n⚠️  Note: On Linux, you may need to run with 'sudo' for full functionality")
    elif system == "Darwin":
        print("\n⚠️  Note: On macOS, you may be prompted for keychain access")
    
    input("\nPress Enter to continue...")
    
    scanner = WiFiScanner()
    
    # Scan for available networks
    available_networks = scanner.scan_available_networks()
    
    # Get saved passwords
    saved_passwords = scanner.get_saved_passwords()
    
    # Display results
    scanner.display_results(available_networks, saved_passwords)
    
    print("\n✅ Scan complete!\n")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Scan interrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ An error occurred: {e}")
        sys.exit(1)
