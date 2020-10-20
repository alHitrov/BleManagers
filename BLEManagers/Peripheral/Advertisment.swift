//
//  AdvertismentData.swift
//  BLEManagers
//
//  Created by Alexey on 20.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import CoreBluetooth

struct Advertisment {
	
	var value:[String:Any] = [CBAdvertisementDataServiceUUIDsKey:[UUIDs.primaryServiceUUID]]
}
