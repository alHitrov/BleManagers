//
//  Transfer.swift
//  BLEManagers
//
//  Created by Alexey on 15.09.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import Foundation

struct Transfer {
	
	var totalDataToSend:Data!
	var sendDataIndex:Int = 0
	var amountToSend:Int { return totalDataToSend.count - sendDataIndex }
	var mtu:Int = 0
	var isAllSend:Bool {
		return sendDataIndex >= totalDataToSend.count
	}
	var didSend:Bool {
		return mtu <= totalDataToSend.count
	}
	
	private var savedChunk:Data? = nil
	
	
	init(dataToSend:Data) {
		totalDataToSend = dataToSend
	}
	
	mutating func nextChunk() -> Data? {
		
		if savedChunk != nil {
			return savedChunk
		}
		
		if (isAllSend) {
			return nil
		}
		
		let currentAmountToSend = min(amountToSend, mtu)
		
		let chunk = totalDataToSend.subdata(in: sendDataIndex..<(sendDataIndex + currentAmountToSend))
		savedChunk = chunk
		
		sendDataIndex += currentAmountToSend
		
		print(String(format: "chunk %d sent %d total: %d", chunk.count, sendDataIndex, totalDataToSend.count))
		
		return chunk
	}
	
	mutating func chunkTransfered() {
		savedChunk = nil
	}
	
}
