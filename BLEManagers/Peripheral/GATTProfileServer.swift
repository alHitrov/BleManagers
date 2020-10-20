//
//  GATTServerProfile.swift
//  BLEManagers
//
//  Created by Alexey on 20.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//
import CoreBluetooth

struct GATTProfileServer {
	
	init() {
		primaryService.characteristics = [readCharacteristic, transferCharacteristic]
	}
		
	var services:[CBMutableService] {[primaryService]}
	
	var primaryService:CBMutableService = CBMutableService(type: UUIDs.primaryServiceUUID, primary: true)
	
	var readCharacteristic:CBMutableCharacteristic =
		CBMutableCharacteristic(type: UUIDs.readCharacteristicUUID,
								properties: [.read],
								value: "some identificator".data(using: .utf8),
								permissions: [.readable])
	
	var transferCharacteristic:CBMutableCharacteristic =
		CBMutableCharacteristic(type: UUIDs.transferCharacteristicUUID,
								properties: [.notify, .writeWithoutResponse],
								value: nil,
								permissions: [.readable, .writeable])
}
