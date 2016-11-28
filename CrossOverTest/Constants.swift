//
//  Constants.swift
//  CrossOverTest
//
//  Created by abhijeet upadhyay on 22/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import Foundation


struct Constants {
    
    //Different API end points.
    static let serverURL = "http://localhost:8080"
    static let registerURL = "/api/v1/register"
    static let placesURL = "/api/v1/places"
    static let paymentURL = "/api/v1/rent"
    
    //Login page Error Messeges.
    static let loginError = "Login failed with error"
    static let emptyPassword =  "Please confirm if password is provided!!!"
    static let invalidEmailID = "Please check if emailID is valid!!!"
    static let emptyEmailID = "Please enter emailID!!!"

    //Signup Error
    static let suSuccess = "Signup is successfully done.Now you can login."
    static let suFailed = "Sign up failed with error"
    static let suPasswordNotMatching = "Passwords are not matching!!!"
    static let suPasswordsProvided = "Please confirm if password and confirm password both are provided!!!"
    static let suEmailValid = "Please check if emailID is valid!!!"
    static let suEmailEmpty = "Please enter emailID!!!"

    //Places
    static let plRentBike = "Would you like to rent bike at "

    //Credit card payment
    static let crSuccess = "Thank You! Payment is successfull, you can come and collect your bike or try renting more also."
    static let crWrong = "Something went wrong, Please try again!!!"
    static let crCVV = "Please enter right cvv with 3 numbers."
    static let crNotValid = "Credit card is not valid!!!"
    static let crEveryInfo = "Every information is necessary, Please fill all the filds!!!"
}
