//
//  CentralViewController.swift
//  BLEManagers
//
//  Created by Alexey on 24.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import UIKit

class CentralViewController: ViewController {

	@IBOutlet weak var textView: UITextView!	
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var connectButton: UIButton!
	@IBOutlet weak var disconnectButton: UIButton!
	
	@IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
	
	var centralManager:CentralManager?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		textView.text = ""
		textView.delegate = self
		
        centralManager = CentralManager()
		centralManager?.writeLog = {(text) in self.textViewAppend(message: text)}
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		centralManager?.disconnect()
	}
	
	func textViewAppend(message:String) {
		textView.text.append("\(message) \n")
		scrollTextView()
	}
	func scrollTextView() {
		let range = NSRange(location: textView.text.count - 1, length: 0)
		textView.scrollRangeToVisible(range)
	}
	
	@IBAction func search(_ sender: Any) {
		centralManager?.search()
	}
	@IBAction func connect(_ sender: Any) {
		centralManager?.connect()
	}
	@IBAction func disconnect(_ sender: Any) {
		centralManager?.disconnect()
	}
	
	//MARK: textView functions
	override func clearText() {
		super.clearText()
		textView.text = ""
	}
	override func sendTextDismissKeyboard() {
		super.sendTextDismissKeyboard()
		textView.resignFirstResponder()
		centralManager?.send(text: textToSend)
	}
	override func sendLongText() {
		super.sendLongText()
		
		centralManager?.send(text: TestKit.veryLongString())
	}
	
	override func keyboardNotification(notification: NSNotification) {
		super.keyboardNotification(notification: notification)
		
		if let userInfo = notification.userInfo {
			
			self.keyboardHeightLayoutConstraint?.constant = keyboardHeightConstraint
		
			animateKeyboardInterfaceChanges(userInfo: userInfo)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {self.scrollTextView()}
		}
	}
}
