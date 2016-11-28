//
//  CrossOverTestTests.swift
//  CrossOverTestTests
//
//  Created by abhijeet upadhyay on 21/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import XCTest

@testable import CrossOverTest

class CrossOverTestTests: XCTestCase {
    
    //session lazy var
    lazy var session: URLSession = {
        return URLSession.shared
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Test if server is working or not
    func testServerWorking() {
        
        let urlStringValue = "http://localhost:8080"
        
            // create NSURL instance
            if let url = NSURL(string: urlStringValue) {
                // check if your application can open the NSURL instance
                if !UIApplication.shared.canOpenURL(url as URL){
                
                    XCTFail()
                }
            }
    }
    
    //Test if login API is working , same way all other API calls can be tested.
    func testLoginAPI(){
    
        let expectationValue = expectation(description: "Testing Async Login API call Works!")
        
        let json:[String:String] = ["email":"crossover@crossover.com","password":"crossover"]
        
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
                    
                    return
                }
                do {
                   expectationValue.fulfill();
                    print("Everything is fine here")
                }
            })
            task.resume()
        }
        catch{
            print(error)
        }
        
        self.waitForExpectations(timeout: 5) { error in
            if (error != nil){
                XCTAssertNil("Some this went wrong")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
