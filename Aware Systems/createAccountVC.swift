//
//  createAccountVC.swift
//  Aware Systems
//
//  Created by Maxwell on 5/22/15.
//  Copyright (c) 2015 Aware Systems LLC. All rights reserved.
//

import UIKit

class createAccountVC: UIViewController
{
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var accountPassword: UITextField!
    
    @IBOutlet weak var passVerify: UITextField!
    
    @IBOutlet weak var cellNumber: UITextField!
    
    @IBOutlet weak var passErrorMessage: UILabel!
    
    @IBOutlet weak var emailErrorMessage: UILabel!
    
    @IBOutlet weak var phoneErrorMessage: UILabel!
    
    @IBOutlet weak var Submit: UIButton!
    

    
    var emailCheck: Bool = false;
    var passCheck: Bool = false;
    var phoneCheck: Bool = false;
    var accountPasswordSaved: String = ""
    var passVerifySaved: String = ""
    var emailSaved: String = ""
    var cellNumberSaved: String = ""
    
  
    
    @IBAction func emailAction(sender: AnyObject) {
        emailSaved = email.text
        var test:Bool = isValidEmail(emailSaved)
        
        if(test != true)
        {
            emailErrorMessage.hidden = false
            emailCheck = false
        }
            
        else
        {
            emailErrorMessage.hidden = true
            emailCheck = true
        }
        
        submitCheck()
    }
    
    @IBAction func accountPasswordAction(sender: AnyObject) {
        accountPasswordSaved = accountPassword.text
    }

    
    @IBAction func passVerifyAction(sender: AnyObject) {
        
         passVerifySaved = passVerify.text
        
        if(passVerifySaved != accountPasswordSaved)
        {
            passErrorMessage.hidden = false
            passCheck = false
        }
        
        else
        {
         passErrorMessage.hidden = true
         passCheck = true
        }
        submitCheck()
    }
    

    @IBAction func cellNumberAction(sender: AnyObject) {
        
        cellNumberSaved = cellNumber.text
        
        var test:Bool = isValidPhone(cellNumberSaved)
        
        if(test != true)
        {
            phoneErrorMessage.hidden = false
            phoneCheck = false
        }
            
        else
        {
            phoneErrorMessage.hidden = true
            phoneCheck = true
        }
        
        submitCheck()
        
    }
    
    @IBAction func Submit(sender: AnyObject) {
        
    performSegueWithIdentifier("RegisterSubmit", sender: Submit)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isValidPhone(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let phoneRegEx = "[0-9]{10}"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluateWithObject(testStr)
    }
    
    func submitCheck(){
    if((phoneCheck==true)&&(emailCheck==true)&&(passCheck==true))
        {
            Submit.hidden = false
        }
    }
    
    func writeJson(email:String , phone:String , password:String )
    {
        let file = "userJSON.json"
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            var text =  "{ \"email\": \""+email+"\", \"phone\": \""+phone+"\", \"password\": \""+password+"\" }"
            
            //writing
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
            
            //reading
            let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            
            println(text2)
            
           
        }
    }
    
    

}

