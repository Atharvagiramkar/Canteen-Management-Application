#!/usr/bin/env python3
"""
Basic tests for WiFi Scanner script
"""

import unittest
import sys
import os

# Add parent directory to path to import wifi_scanner
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from wifi_scanner import WiFiScanner


class TestWiFiScanner(unittest.TestCase):
    """Test cases for WiFi Scanner"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.scanner = WiFiScanner()
    
    def test_scanner_initialization(self):
        """Test that scanner initializes correctly"""
        self.assertIsNotNone(self.scanner)
        self.assertIsNotNone(self.scanner.system)
        self.assertIn(self.scanner.system, ['Windows', 'Linux', 'Darwin'])
    
    def test_scan_available_networks(self):
        """Test that scan_available_networks returns a list"""
        networks = self.scanner.scan_available_networks()
        self.assertIsInstance(networks, list)
    
    def test_get_saved_passwords(self):
        """Test that get_saved_passwords returns a dict"""
        passwords = self.scanner.get_saved_passwords()
        self.assertIsInstance(passwords, dict)
    
    def test_get_wireless_interface_linux(self):
        """Test wireless interface detection on Linux"""
        if self.scanner.system == 'Linux':
            interface = self.scanner._get_wireless_interface_linux()
            # Interface can be None if no wireless adapter found
            if interface is not None:
                self.assertIsInstance(interface, str)
                self.assertTrue(len(interface) > 0)
    
    def test_display_results(self):
        """Test that display_results doesn't crash"""
        try:
            self.scanner.display_results([], {})
            self.scanner.display_results(['Network1'], {'Network1': 'password'})
        except Exception as e:
            self.fail(f"display_results raised an exception: {e}")


if __name__ == '__main__':
    # Run tests
    print("Running WiFi Scanner Tests...")
    print("=" * 60)
    
    # Create test suite
    suite = unittest.TestLoader().loadTestsFromTestCase(TestWiFiScanner)
    
    # Run tests
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    
    # Print summary
    print("\n" + "=" * 60)
    if result.wasSuccessful():
        print("✅ All tests passed!")
    else:
        print("❌ Some tests failed")
        sys.exit(1)
