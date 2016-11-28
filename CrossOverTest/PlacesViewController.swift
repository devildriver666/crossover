//
//  PlacesViewController.swift
//  CrossOverTest
//
//  Created by abhijeet upadhyay on 22/11/16.
//  Copyright © 2016 crossover. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacesViewController: UIViewController,GMSMapViewDelegate {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    //Logout action to re login or new sign up.
    
    @IBAction func logoutAction(_ sender: Any) {
        
        OperationQueue.main.addOperation({
            //cleanign access token and dismissing view on main thread.
            NetworkingFactory.sharedInstance.accessToken = nil
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    var placesModelArray = [PlacesModel]()
    
    @IBOutlet weak var googleMap: GMSMapView!
   
       override func viewDidLoad() {
        super.viewDidLoad()
        getRentalPlaces()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRentalPlaces()  {
        
        NetworkingFactory.sharedInstance.executeGettingPlaces { (success, responseObject, error) in
        
             print("ResponseObject -> \(responseObject)")
            
            //Creting a parsing operation for data parsing if data is big it will help.
            let parsingOperation = BlockOperation{
                
                if let placeArray = responseObject {
                    
                    // print("Json Array = \(interestArray)")
                    if let placeArray = placeArray["results"] as? [[String: AnyObject]] {
                        
                        for place in placeArray {
                            
                            let placesModel = PlacesModel()
                            placesModel.name = place["name"] as? String
                            let location = place["location"] as? NSDictionary
                            placesModel.location.lat = location?["lat"] as? Double
                            
                             placesModel.location.long = location?["lng"] as? Double
                            
                            self.placesModelArray.append(placesModel)
                            
                        }
                    }
                }
            }
            
            let queue = OperationQueue()
          
            //After parsing Map needs to be reloded.
            let reloadOperation = BlockOperation{
                
                OperationQueue.main.addOperation({
                    
                    self.loadMap()
                })
            }
            //Dependency is necessary so that map loads after once parsing is done.
            reloadOperation.addDependency(parsingOperation)
            let operationsArr = [parsingOperation,reloadOperation]
            queue.addOperations(operationsArr, waitUntilFinished: false)
        }
    }
    
    //Load map with all the markers fetched from API.
    
    func loadMap() {
        
        OperationQueue.main.addOperation({
            
            var i:Int = 0
            self.googleMap.delegate = self;
            
            for _ in self.placesModelArray {
                // Need to figure out what could be the best zoom level. Will do if I find time.
                
                let camera = GMSCameraPosition.camera(withLatitude: self.placesModelArray[i].location.lat!, longitude: self.placesModelArray[i].location.long!, zoom: 11.0)
                let marker = GMSMarker()
                 self.googleMap.camera = camera
                marker.position = CLLocationCoordinate2D(latitude:self.placesModelArray[i].location.lat!, longitude: self.placesModelArray[i].location.long!)
                marker.title = self.placesModelArray[i].name
            
                marker.map = self.googleMap
                
                i = i + 1;
            }
        })
    }
    
    //tap marker value used to call for payment and show alert.
    
    public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
    
        let rentString = Constants.plRentBike + marker.title! + "?"
        showAlert(rentString)
    }
    
    func showAlert(_ alertMesg:String) {
        
        let alertController = UIAlertController(title: "Rent", message: alertMesg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            DispatchQueue.main.async {
                
                //Call Payment Controller for next job
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let creditViewController = storyBoard.instantiateViewController(withIdentifier: "credit") as! CreditCardInformationViewController
                self.present(creditViewController, animated:true, completion:nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
