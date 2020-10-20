//
//   CentralManagerDelegate.swift
//  BLEManagers
//
//  Created by Alexey on 24.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import CoreBluetooth

extension CentralManager: CBCentralManagerDelegate {
	
	//MARK: Discovery
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		
		guard let localName = peripheral.name else {return}
		
		writeLog("Name:\(localName) RSSI:\(String(format: "%.2", RSSI.doubleValue)) UUID:\(peripheral.identifier.uuidString)")
		writeLog("Advertisment data: \(advertisementData)")
			
		device = peripheral
		manager.stopScan()

		writeLog("Scan stopped")
	}
	
	//MARK: Connect/disconnect
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		
		writeLog("Connected: \(peripheral.name!)")
		
		device?.delegate = self
		device?.discoverServices(nil)
	}
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		
		writeLog("Disconnected: \(device?.state == .disconnected ? "YES" : "NO")")
	}
	
	//MARK: Statetes
	internal func centralManagerDidUpdateState(_ central: CBCentralManager) {

		switch central.state {
		case .poweredOn:
			// ... so start working with the peripheral
			writeLog("GATT client started ...\n")
			
		case .poweredOff:
			writeLog("CBManager is powered off")
			// In a real app, you'd deal with all the states accordingly
			return
		case .resetting:
			writeLog("CBManager is resetting")
			// In a real app, you'd deal with all the states accordingly
			return
		case .unauthorized:
			// In a real app, you'd deal with all the states accordingly
			if #available(iOS 13.0, *) {
			   switch central.authorization {
			   case .denied:
				   writeLog("You are not authorized to use Bluetooth")
			   case .restricted:
				   writeLog("Bluetooth is restricted")
			   default:
				   writeLog("Unexpected authorization")
			   }
			} else {
			   // Fallback on earlier versions
			}
			return
		case .unknown:
			writeLog("CBManager state is unknown")
			// In a real app, you'd deal with all the states accordingly
			return
		case .unsupported:
			writeLog("Bluetooth is not supported on this device")
			// In a real app, you'd deal with all the states accordingly
			return
		@unknown default:
			writeLog("A previously unknown central manager state occurred")
			// In a real app, you'd deal with yet unknown cases that might occur in the future
			return
		}
	}
}
