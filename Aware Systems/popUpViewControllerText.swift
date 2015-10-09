//
//  popUpViewControllerText.swift
//  Aware Systems
//
//  Created by Maxwell on 9/13/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit
import MessageUI

class popUpViewControllerText: UIViewController, MFMessageComposeViewControllerDelegate {
    
    
    
    @IBAction func textContactOneAction(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = ["7757454726"]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }

    
    @IBAction func textContactTwoAction(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = ["3102001912"]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    @IBAction func textContactThreeAction(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = ["5125899814"]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled", terminator: "")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed", terminator: "")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent", terminator: "")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    

    
        override var preferredContentSize: CGSize {
            get {
                return CGSize(width: 150, height: 175)
            }
            set {
                super.preferredContentSize = newValue
            }
        }
}
