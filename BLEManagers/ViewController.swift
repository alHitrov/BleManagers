//
//  ViewController.swift
//  BLEManagers
//
//  Created by Alexey on 25.08.2020.
//  Copyright © 2020 GETMOBIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	lazy var doneButton :UIBarButtonItem  = {
		UIBarButtonItem.init(title: "Send",
							 style: .plain,
							 target: self,
							 action: #selector(ViewController.sendTextDismissKeyboard))
	}()
	
	
	lazy var clearTextView: UIBarButtonItem = {
		UIBarButtonItem.init(title: "Clear",
							 style: .plain,
							 target: self,
							 action: #selector(ViewController.clearText))
	}()
	
	lazy var testTransfer: UIBarButtonItem = {
		UIBarButtonItem.init(title: "Send long text",
							 style: .plain,
							 target: self,
							 action: #selector(ViewController.sendLongText))
	}()
	
	var textToSend:String = ""
	var keyboardHeightConstraint:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItems = [doneButton, testTransfer, clearTextView]

		doneButton.isEnabled = false
		
		NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil)
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	@objc func clearText() {
	}
	@objc func sendTextDismissKeyboard() {
		doneButton.isEnabled = false
	}
	
	@objc func sendLongText() {

	}

	
	@objc func keyboardNotification(notification: NSNotification) {
			
		if let userInfo = notification.userInfo {
			
			let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
			let endFrameY = endFrame?.origin.y ?? 0
			
			if endFrameY >= UIScreen.main.bounds.size.height {
				keyboardHeightConstraint = 0.0
			} else {
				keyboardHeightConstraint = endFrame?.size.height ?? 0.0
			}
		}
	}
	
	func animateKeyboardInterfaceChanges(userInfo:[AnyHashable : Any]) {
		
		let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
		let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
		let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
		let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
		
		
		UIView.animate(withDuration: duration,
					   delay: TimeInterval(0),
					   options: animationCurve,
					   animations: { self.view.layoutIfNeeded() },
					   completion: nil)
	}
}

extension ViewController:UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		
		textToSend += text
		return true
	}
	
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		
		textToSend = ""
		doneButton.isEnabled = true
	}
}
