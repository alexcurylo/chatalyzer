//
//  ViewController.swift
//  Chatalyzer
//
//  Created by alex on 2016-04-28.
//  Copyright © 2016 Trollwerks Inc. All rights reserved.
//

import UIKit

/// Takes string input from user and displays its parsed contents.
class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    @IBOutlet weak var chatView: UITextField!
    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var stackBottom: NSLayoutConstraint!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatView.addTarget(self, action: #selector(onChatChange), forControlEvents: .EditingChanged)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChange), name:UIKeyboardWillChangeFrameNotification, object:nil)
    }

    // MARK: - Text input handling
    
    func onChatChange(sender: AnyObject?) {
        resultView.text = chatView.text?.chatalysis()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    func keyboardWillChange(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        stackBottom.constant -= originDelta
        view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

