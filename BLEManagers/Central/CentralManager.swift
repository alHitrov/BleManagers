
import CoreBluetooth

class CentralManager:NSObject {
	
	var manager:CBCentralManager!
	private let managerOptions:[String:Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:false,
											   CBCentralManagerOptionShowPowerAlertKey:false]
	var isMangerOn:Bool {return manager.state == .poweredOn}
	
	var device:CBPeripheral?
	var writeLog:((String)->Void) = {(text:String) in print(text)}
	
	var transfer:Transfer?
	
	override init() {
		super.init()
		
		manager = CBCentralManager(delegate: self, queue: nil)
	}
	
	func search() {
		if (isMangerOn && !manager.isScanning) {
			manager.scanForPeripherals(withServices: [UUIDs.primaryServiceUUID], options: managerOptions)
		}
	}
	func connect() {
		guard let connectingDevice = device else {return}
		let isNotConnected = connectingDevice.state != .connected && connectingDevice.state != .connecting
		if (isMangerOn && isNotConnected) {
			manager.connect(connectingDevice, options: nil)
		}
	}
	func disconnect() { 
		guard let cancelingDevice = device else {return}
		if (isMangerOn && cancelingDevice.state == .connected) {
			manager.cancelPeripheralConnection(cancelingDevice)
		}
	}
	
	func send(text:String) {
			
		transfer = Transfer(dataToSend: text.data(using: .utf8)!)
		if let mtu = device?.maximumWriteValueLength (for: .withoutResponse) {
			transfer?.mtu = mtu
			
			sendData()
		}
	}
	
	private func sendData() {
		
		guard let transferCharacteristic = characteristic(with: UUIDs.transferCharacteristicUUID) else {
			return
		}
		
		let didSend = transfer!.didSend
		
		if (!didSend && !transfer!.isAllSend) {
			
			device?.writeValue(transfer!.totalDataToSend, for: transferCharacteristic, type: .withoutResponse)
			return
		}
		
		while didSend {
			
			guard let chunk = transfer!.nextChunk() else {return}
			
			device?.writeValue(chunk, for: transferCharacteristic, type: .withoutResponse)
			transfer?.chunkTransfered()
			
			if transfer!.isAllSend {
				return
			}
		}
	}
	
	func characteristic(with UUID:CBUUID) -> CBCharacteristic? {
		
		guard let service:CBService = device?.services?.first(where: { $0.uuid == UUIDs.primaryServiceUUID}) else {
			return nil
		}
		
		return service.characteristics!.first(where: { ($0.uuid == UUID) } )
	}
}




