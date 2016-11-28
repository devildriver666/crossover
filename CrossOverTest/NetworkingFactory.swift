//
//  NetworkingFactory.swift
//  CrossOverTest
//
//  Created by abhijeet upadhyay on 21/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import UIKit


class NetworkingFactory: NSObject {
    
    //Singleton Created
    static let sharedInstance = NetworkingFactory()
    
    var accessToken:String?

    // Private init method.
    //initialize rechability and rechability check.
    
    fileprivate override init() {
        print(#function)
        
    }
    
    //Callback typealiases for easy use.
    public typealias SignupCompleted = ((Bool, AnyObject? ,NSError?) -> Void)
    public typealias LoginCompleted = ((Bool, AnyObject? ,NSError?) -> Void)
    public typealias PlacesFetchCompleted = ((Bool, AnyObject? ,NSError?) -> Void)
    public typealias CreditCardInfoCompleted = ((Bool, AnyObject? ,NSError?) -> Void)
    
    //session lazy var
    lazy var session: URLSession = {
        return URLSession.shared
    }()
    
    
    // Login POST Request call with JSON Object call back.
    public func executeLogin(_ login:String , _ password:String, _ success:@escaping SignupCompleted){
    
        let json:[String:String] = ["email":login,"password":password]
        
        do{
            let jsonData =  try  JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let stringURI = Constants.serverURL+Constants.registerURL
            // create post request
            let url = URL(string: stringURI)!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    success(false, nil , error as NSError?)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                    print("Result -> \(result)")
                    self.accessToken =  result["accessToken"] as? String
                    success(true, result as AnyObject? , nil)
                    
                } catch {
                    print("Error -> \(error)")
                }
            })
            task.resume()
        }
        catch{
            print(error)
        }
    }
    
    // Signup POST Request call with JSON Object call back.
    public func executeSignup(_ login:String , _ password:String,_ success:@escaping LoginCompleted ){
        
        let json:[String:String] = ["email":login,"password":password]
        
        do{
            let jsonData =  try  JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let stringURI = Constants.serverURL+Constants.registerURL
            // create post request
            let url = URL(string: stringURI)!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
                   
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    success(false, nil , error as NSError?)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]

                     print("Result -> \(result)")
                    success(true, result as AnyObject? , nil)
                    
                } catch {
                    print("Error -> \(error)")
                }
            })
            task.resume()
        }
        catch{
            print(error)
        }
    }
    
    // Places GET Request call with JSON Object call back.
    public func executeGettingPlaces(_ success:@escaping PlacesFetchCompleted ){
        
            let stringURI = Constants.serverURL+Constants.placesURL
            // create get request
            let url = URL(string: stringURI)!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue(self.accessToken, forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    success(false, nil , error as NSError?)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                   // print("Result -> \(result)")
                    success(true, result as AnyObject? , nil)
                    
                } catch {
                    print("Error -> \(error)")
                }
            })
            task.resume()
    }
    
    // Credit card POST Request call with JSON Object call back.
    public func executePlymentWithCreditCard(_ name:String , _ cardnumber:String, _ expiryDate:String, _ cvvnumber:String,_ success:@escaping CreditCardInfoCompleted ){
        
        let json:[String:String] = ["number":cardnumber,"name":name ,"expiration":expiryDate ,"code":cvvnumber]
        
        do{
            let jsonData =  try  JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let stringURI = Constants.serverURL+Constants.paymentURL
            // create post request
            let url = URL(string: stringURI)!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            request.setValue(self.accessToken, forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    success(false, nil , error as NSError?)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                    print("Result -> \(result)")
                    success(true, result as AnyObject? , nil)
                    
                } catch {
                    print("Error -> \(error)")
                }
            })
            task.resume()
        }
        catch{
            print(error)
        }
    }
}
