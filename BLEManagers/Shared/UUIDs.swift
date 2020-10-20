//
//  UUIDs.swift
//  BLEManagers
//
//  Created by Alexey on 24.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import Foundation
import CoreBluetooth

struct UUIDs {
	static let primaryServiceUUID = CBUUID(string: "bf52e2d6-ff52-43cb-99a0-872fa3dde94f")
	static let readCharacteristicUUID = CBUUID(string: "f438775d-e605-42b8-abe7-6e31ed52ea87")
	static let transferCharacteristicUUID = CBUUID(string: "a82ae020-e171-42f8-a31c-5f612926f041")
}
