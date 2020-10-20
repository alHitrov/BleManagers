//
//  PeripheralDelegate.swift
//  BLEManagers
//
//  Created by Alexey on 24.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import CoreBluetooth

extension CentralManager:CBPeripheralDelegate {
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard let services = device?.services else { return }
		 
		let filterServices = services.filter { (service) -> Bool in
			service.uuid == UUIDs.primaryServiceUUID
		}

		for service in filterServices {
			writeLog("Discovered service: \(service)")
			device?.discoverCharacteristics(nil, for: service)
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		
		guard let characteristics = service.characteristics else {return}
		
		for characteristic in characteristics  {
			
			writeLog("Discovered characteristic: \(characteristic.uuid.uuidString) \(characteristic.properties) descriptors count:\(characteristic.descriptors?.count ?? 0)")

			if (characteristic.uuid == UUIDs.readCharacteristicUUID) {
				device?.readValue(for: characteristic)
			}
			
			if (characteristic.uuid == UUIDs.transferCharacteristicUUID) {
				device?.setNotifyValue(true, for: characteristic)
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		
		writeLog("READ: \(String(decoding: characteristic.value!, as: UTF8.self))")
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
		
		writeLog("\(#function) characteristic is subscribing")
	}
	
}
