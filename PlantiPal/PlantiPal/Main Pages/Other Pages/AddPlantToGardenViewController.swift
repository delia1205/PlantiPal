//
//  AddPlantToGardenViewController.swift
//  PlantiPal
//
//  Created by Delia on 04/06/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class AddPlantToGardenViewController: UIViewController {

    @IBOutlet weak var plantNameField: UITextView!
    @IBOutlet weak var plantSpeciesField: UITextView!
    @IBOutlet weak var addPlantButton: UIButton!
    @IBOutlet weak var isOutsideSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plantNameField.paddingSpace()
        plantSpeciesField.paddingSpace()
        plantSpeciesField.text = identifiedPlant?.species
    }

    @IBAction func addPlantTapped(_ sender: Any) {
        print("adding plant ", plantNameField.text)
        
        var isOutsideBool : Bool = false
        let isOutsideValue = isOutsideSlider.value
        if isOutsideValue == 0 {
            isOutsideBool = false
        }
        else if isOutsideValue == 1 {
            isOutsideBool = true
        }
        else {
            showIncorrectSliderValueAlert(title: "Incorect value for slider", message: "Please move the slider to one side completely, either outside or inside.")
        }
        let plantName = plantNameField.text
        let plantSpecies = plantSpeciesField.text
        let gardenObject = PFObject(className: "Garden")
        gardenObject["username"] = loggedUser.user.username
        gardenObject["plantName"] = plantName
        gardenObject["plantSpecies"] = plantSpecies
        let image = identifiedPlant?.photo
        let data = UIImagePNGRepresentation(image!)
        gardenObject["plantPhoto"] = PFFileObject(data: data!)
        gardenObject["isOutside"] = isOutsideBool
        gardenObject.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                print("plant added")
                self.displayAlertAndSegue(withTitle: "Plant added to garden", message: "The new plant, " + self.plantNameField.text + " was added successfully.")
            }
            else {
                print("some error")
                print(error.debugDescription)
                self.displayAlertAndSegue(withTitle: "Error", message: "There was a problem while adding this jplant to your garden. Please try again.")
            }
        }
    }
    
    func displayAlertAndSegue(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    notifAccess = true;
                } else {
                    notifAccess = false;
                }
            }
            
            self.performSegue(withIdentifier: "backToSpecies", sender: self)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func showIncorrectSliderValueAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UITextView {
    func paddingSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 4, bottom: 4, right: 4)
    }
}
