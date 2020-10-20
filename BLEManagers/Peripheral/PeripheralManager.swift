
import UIKit
import CoreBluetooth

class PeripheralManager: NSObject {
	
	var manager:CBPeripheralManager!
	var connectedCentral: CBCentral?
	var gattProfile = GATTProfileServer()
	var writeLog:((String)->Void) = {(text:String) in print(text)}
	var isSubscribed:Bool = false
	
	var transfer:Transfer?
		
	override init() {
		super.init()
		manager = CBPeripheralManager(delegate: self, queue: nil)
	}
	
	func setLog(handler:@escaping((String)->Void))->Void {
		writeLog = handler
	}
	
	func prepareGATT() {
		
		for service in gattProfile.services {
			manager.add(service)
			
			writeLog("Primary service: \(service.uuid.uuidString)")
			
			for characteristic in service.characteristics! {
				writeLog("Characteristic: \(characteristic.uuid.uuidString)")
			}
		}
		
		writeLog("GATT prepared ...\n")
	}
	
	func startAdvertising() {
		
		if (manager.state == .poweredOn && !manager.isAdvertising) {
			manager.startAdvertising(Advertisment().value)
		}
	}
	
	func stopAdvertising() {
		manager.stopAdvertising()
	}
	
	func send(text:String) {
		
		if (manager.state == .poweredOn && isSubscribed) {
			
			transfer = Transfer(dataToSend: text.data(using: .utf8)!)
			if let mtu = connectedCentral?.maximumUpdateValueLength {
				transfer?.mtu = mtu
				print("Maximum data to send: \(mtu)")
			}
			
			
			sendData()
			
		}
	}

	func sendData() {
			
		var didSend = transfer!.didSend
		
		if (!didSend && !transfer!.isAllSend) {
			
			manager.updateValue(transfer!.totalDataToSend, for: gattProfile.transferCharacteristic, onSubscribedCentrals: nil)
			return
		}
		
		while didSend {
			
			guard let chunk = transfer!.nextChunk() else {return}
			
			if chunk.count == 372 {
				print("it will be send now")
				print("\(String(decoding: chunk, as: UTF8.self ))")
			}
			
			didSend = manager.updateValue(chunk, for: gattProfile.transferCharacteristic, onSubscribedCentrals: nil)

			if didSend {
				transfer?.chunkTransfered()
			}
		}
	}
}






