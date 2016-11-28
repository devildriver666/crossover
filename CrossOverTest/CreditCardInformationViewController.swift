//
//  CreditCardInformationViewController.swift
//  CrossOverTest
//
//  Created by abhijeet upadhyay on 22/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import UIKit
import CreditCardValidator

class CreditCardInformationViewController: UIViewController {

    //Dont want to do payment or change bike place.
    @IBAction func cancelPayment(_ sender: Any) {
        
        OperationQueue.main.addOperation({
            self.dismiss(animated: true, completion: nil)
        })
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var cvvcodeText: UITextField!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var cardNumberText: UITextField!
    
    
    //Send card info to verify and make payment.
    
    @IBAction func sendCardinfo(_ sender: Any) {
        
        if let cardNumber = cardNumberText.text, !cardNumber.isEmpty, let name = nameText.text, !name.isEmpty, let expiryDate = expiryDate.text, !expiryDate.isEmpty, let cvvcode = cvvcodeText.text, !cvvcode.isEmpty {
            
            let v = CreditCardValidator()
            
            //trimming all white spaces if user inputs. [habbit of some people]
            let cardNumberTextValue =  cardNumberText.text!.trimmingCharacters(in: .whitespaces)
            
            //validating credit card
            if v.validate(string: cardNumberTextValue) {
                // Card number is valid
                if cvvcode.characters.count == 3{
                
                    NetworkingFactory.sharedInstance.executePlymentWithCreditCard(name, cardNumber, expiryDate, cvvcode, { (success, object, error) in
                      
                        if success {
                            //On main thread.
                            OperationQueue.main.addOperation({
                                
                                 self.showAlert(Constants.crSuccess,true)
                            })
                        }
                        else{
                            self.showAlert(Constants.crWrong,false)
                        }
                    })
                }
                else{
                    showAlert(Constants.crCVV,false)
                }
            } else {
                showAlert(Constants.crNotValid,false)
            }
        }
        else{
            showAlert(Constants.crEveryInfo,false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding cancel button.
        cvvcodeText.clearButtonMode = .whileEditing
        expiryDate.clearButtonMode = .whileEditing
        nameText.clearButtonMode = .whileEditing
        cardNumberText.clearButtonMode = .whileEditing

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //These function in every controller are necessary, needed for specific changes and customization or single function param list will be too long.
    func showAlert(_ error:String , _ success:Bool) {
        
        let alert = UIAlertController(title: "Payment", message: error, preferredStyle: UIAlertControllerStyle.alert)
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
}
