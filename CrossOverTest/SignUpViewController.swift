//
//  SignUpViewController.swift
//  CrossOverTest
//
//  Created by abhijeet upadhyay on 21/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //Data input Outlets.
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginTextField.clearButtonMode = .whileEditing
        passTextField.clearButtonMode = .whileEditing
        confirmPassTextField.clearButtonMode = .whileEditing
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Back button to leave sign up page.
    @IBAction func backAction(_ sender: Any) {
        
        OperationQueue.main.addOperation({
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //Signup Input fields varification and Login call.
    @IBAction func signupAction(_ sender: Any) {
        
        if let emailD = loginTextField.text, !emailD.isEmpty, emailD.characters.count <= 128{
            
            if(isValidEmail(testStr: emailD)){
                
                if let password = passTextField.text, let confirmPassword = confirmPassTextField.text, !password.isEmpty, !confirmPassword.isEmpty {
                    
                    if password == confirmPassword && password.characters.count <= 32{
                        
                        NetworkingFactory.sharedInstance.executeSignup(emailD, password, { (success, response, error) in
                            if success {
                                
                                OperationQueue.main.addOperation({
                                    self.showAlert(Constants.suSuccess, true)
                                })
                            }
                            else{
                                OperationQueue.main.addOperation({ 
                                     self.showAlert(Constants.suFailed + (error?.description)!, false)
                                })
                            }
                        })
                    }
                    else{
                        // password mismatch warning
                        showAlert(Constants.suPasswordNotMatching, false)
                    }
                }
                else{
                    //Either of password Field empty warning.
                    showAlert(Constants.suPasswordsProvided, false)
                }
            }
            else{
                //Invalid Email ID warning.
                showAlert(Constants.suEmailValid, false)
            }
        }
        else{
            //Email Field Empty Warning.
             showAlert(Constants.suEmailEmpty, false)
        }
    }
    
    //Alerts I am keeping in every individual controller as in future we need to change these and have very different styles and features.
    //Few lines of code wont harm any way, and will be clear for future if customization required.
    //Same kind of code you can see in other classes as well.
    func showAlert(_ error:String, _ success:Bool) {
        
        let alert = UIAlertController(title: "Signup", message: error, preferredStyle: UIAlertControllerStyle.alert)
        if success {
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alert.addAction(okAction)
        }
        else{
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //email validation with predicates
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //textfleild return delegate call
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
