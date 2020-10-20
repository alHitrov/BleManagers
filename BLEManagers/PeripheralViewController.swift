//
//  PeripheralViewController.swift
//  BLEManagers
//
//  Created by Alexey on 24.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import UIKit

class PeripheralViewController: ViewController {
	
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var advertisingSwitch: UISwitch!
	
	var peripheralManager:PeripheralManager?

	@IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {

        super.viewDidLoad()
		
		textView.text = ""
		textView.delegate = self

		
		peripheralManager = PeripheralManager()
		peripheralManager?.writeLog = { (text) in self.textViewAppend(message:text) }
		
		advertisingSwitch.setOn(false, animated: true)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		peripheralManager?.manager.stopAdvertising()
	}
	
	func textViewAppend(message:String) {
		textView.text.append("\(message) \n")
		scrollTextView()
	}
	func scrollTextView() {
		let range = NSRange(location: textView.text.count - 1, length: 0)
		textView.scrollRangeToVisible(range)
	}

    @IBAction func switchChanged(_ sender: Any) {
        
		if advertisingSwitch.isOn {
			peripheralManager?.startAdvertising()
        } else {
            peripheralManager?.stopAdvertising()
        }
    }

	//MARK: textView functions
	override func clearText() {
		super.clearText()
		textView.text = ""
	}
	override func sendTextDismissKeyboard() {
		super.sendTextDismissKeyboard()
		textView.resignFirstResponder()

		peripheralManager?.send(text: textToSend)
	}
	override func sendLongText() {
		super.sendLongText()
		
		peripheralManager?.send(text: TestKit.veryLongString())
	}
	
	//MARK: textView notifications
	override func keyboardNotification(notification: NSNotification) {
		super.keyboardNotification(notification: notification)
		
		if let userInfo = notification.userInfo {
			
			self.keyboardHeightLayoutConstraint?.constant = keyboardHeightConstraint
		
			animateKeyboardInterfaceChanges(userInfo: userInfo)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {self.scrollTextView()}
		}
	}
}
