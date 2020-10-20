//
//  PerpheralManagerDelegate.swift
//  BLEManagers
//
//  Created by Alexey on 24.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import Foundation
import CoreBluetooth

extension PeripheralManager: CBPeripheralManagerDelegate {
	
	//MARK: read/write requests
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
		
		guard let readsValue = request.value else { return }

		writeLog("READ request: \(String(decoding: readsValue, as: UTF8.self ))")
		manager.respond(to: request, withResult: .success)
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
		
		// You should pass in the first request of the array, like this:
		manager.respond(to: requests.first!, withResult: .success)
		
		for request in requests {
			
//			writeLog("\(#function): \(String(describing: request.value))")
			
			// Handle write requst
			guard let writesValue = request.value else { continue }
			writeLog("WRITE request: \(String(decoding: writesValue, as: UTF8.self ))")
		}
	}
	
	//MARK: subscribing/unsubscribing
	func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
		writeLog("\(#function): \(characteristic.uuid.uuidString)")
		
		connectedCentral = central
		isSubscribed = true
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
		
		isSubscribed = false
		print("\(#function): \(characteristic.uuid.uuidString)")
	}
	
	//MARK: status, creating
	func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
		
		switch peripheral.state {
		case .poweredOn:
			// ... so start working with the peripheral
			writeLog("CBManager is powered on")
			prepareGATT()
		case .poweredOff:
			writeLog("CBManager is not powered on")
			// In a real app, you'd deal with all the states accordingly
			stopAdvertising()
			return
		case .resetting:
			print("CBManager is resetting")
			// In a real app, you'd deal with all the states accordingly
			return
		case .unauthorized:
			// In a real app, you'd deal with all the states accordingly
			if #available(iOS 13.0, *) {
			  switch peripheral.authorization {
			  case .denied:
				  print("You are not authorized to use Bluetooth")
			  case .restricted:
				  print("Bluetooth is restricted")
			  default:
				  print("Unexpected authorization")
			  }
			} else {
			  // Fallback on earlier versions
			}
			return
		case .unknown:
			print("CBManager state is unknown")
			// In a real app, you'd deal with all the states accordingly
			return
		case .unsupported:
			print("Bluetooth is not supported on this device")
			// In a real app, you'd deal with all the states accordingly
			return
		@unknown default:
			print("A previously unknown peripheral manager state occurred")
			// In a real app, you'd deal with yet unknown cases that might occur in the future
			return
		}
	}
	
	func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
		
		print("\(#function): ")
		
		sendData()
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
		print("Add service: \(service.uuid.uuidString)")
	}

	//MARK: Advertising
	func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
		if (error == nil) {
			writeLog("Advertising started")
		}
	}
}
