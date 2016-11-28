//
//  ViewController.swift
//  CrossOverTest
//
//  Created by abhijeet upadhyay on 21/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        // Do any additional setup after loading the view, typically from a nib.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Login Input fields varifications and Login call.
    public func loginAction(_ sender: Any) {
        
        if let emailD = loginTextField.text, !emailD.isEmpty,emailD.characters.count <= 128{
            
            if(isValidEmail(testStr: emailD)){
                
                if let password = passwordTextField.text, !password.isEmpty,password.characters.count <= 128 {
                    
                    NetworkingFactory.sharedInstance.executeLogin(emailD, password, { (success, response, error) in
                        
                        //Loading new controller if success
                        if success {
                            DispatchQueue.main.async {
                                
                                //Clean text fileds
                                self.loginTextField.text = ""
                                self.passwordTextField.text = ""
                                
                                //Call Places Controller for next job
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let placesViewController = storyBoard.instantiateViewController(withIdentifier: "places") as! PlacesViewController
                                self.present(placesViewController, animated:true, completion:nil)
                            }
                        }
                        else{
                            OperationQueue.main.addOperation({
                                self.showErrorAlert(Constants.loginError + (error?.description)!)
                            })
                        }
                    })
                }
                else{
                    // password mismatch warning
                    showErrorAlert(Constants.emptyPassword)
                }
            }
            else{
                //Invalid Email ID warning.
                showErrorAlert(Constants.invalidEmailID)
            }
        }
        else{
            //Email Field Empty Warning.
            showErrorAlert(Constants.emptyEmailID)
        }
    }
    
    func showErrorAlert(_ error:String) {
        
        let alert = UIAlertController(title: "Login", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

