//
//  EditGardenPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class EditGardenPageViewController: UIViewController {
    
    @IBOutlet weak var backBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: CGRect(x: 25, y: 280, width: 345, height: 375))
        self.view.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 345, height: 110*gardenPlants.count))
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        if gardenPlants.count == 0 {
            fetchData { (objects, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    for object in objects {
                        let gardenPlantName = object["plantName"] as? String
                        let gardenPlantSpecies = object["plantSpecies"] as? String
                        //let gardenPlantPhoto = object["plantPhoto"] as? UIImage
                        let plant = GardenPlant(name: gardenPlantName!, species: gardenPlantSpecies!)//, photo: gardenPlantPhoto!)
                        gardenPlants.append(plant)
                    }
                    
                    if gardenPlants.count == 0 {
                        let text = "No plants saved in garden."
                        let noPlantsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 345, height: 50))
                        noPlantsLabel.text = text
                        noPlantsLabel.textColor = UIColor(red: 0.10, green: 0.12, blue: 0.09, alpha: 1.00)
                        noPlantsLabel.textAlignment = .center
                        contentView.addSubview(noPlantsLabel)
                    }
                    else {
                        var y = 0
                        for i in 0...gardenPlants.count-1 {
                            var plantLabel : UILabel
                            plantLabel = UILabel(frame: CGRect(x: 0, y: y, width: 300, height: 40))
                            plantLabel.text = gardenPlants[i].name
                            plantLabel.textAlignment = .left
                            plantLabel.backgroundColor = UIColor(red: 0.10, green: 0.12, blue: 0.09, alpha: 0.00)
                            plantLabel.textColor = UIColor(red: 0.31, green: 0.38, blue: 0.32, alpha: 1.00)
                            plantLabel.font = UIFont.systemFont(ofSize: 18)
                            
                            let tapCell = UITapGestureRecognizer(target: self, action: #selector(self.buttonAction))
                            plantLabel.addGestureRecognizer(tapCell)
                            plantLabel.isUserInteractionEnabled = true
                            y = y+45
                            contentView.addSubview(plantLabel)
                        }
                    }
                }
            }
        }
        else {
            var y = 0
            for i in 0...gardenPlants.count-1 {
                var plantLabel : UILabel
                plantLabel = UILabel(frame: CGRect(x: 0, y: y, width: 300, height: 40))
                plantLabel.text = gardenPlants[i].name
                plantLabel.textAlignment = .left
                plantLabel.backgroundColor = UIColor(red: 0.10, green: 0.12, blue: 0.09, alpha: 0.00)
                plantLabel.textColor = UIColor(red: 0.31, green: 0.38, blue: 0.32, alpha: 1.00)
                plantLabel.font = UIFont.systemFont(ofSize: 18)
                
                let tapCell = UITapGestureRecognizer(target: self, action: #selector(self.buttonAction))
                plantLabel.addGestureRecognizer(tapCell)
                plantLabel.isUserInteractionEnabled = true
                y = y+45
                contentView.addSubview(plantLabel)
            }
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
    }
    
    @IBAction func backToSettings(_ sender: Any) {
        performSegue(withIdentifier: "backToSettings", sender: self)
    }
    
    func fetchData(completion: @escaping ([PFObject]?, Error?) -> Void) {
        let query = PFQuery(className: "Garden")
        query.whereKey("username", equalTo: loggedUser.user.username as Any)
        query.findObjectsInBackground { (objects, error) in
            completion(objects, error)
        }
    }
    
    @objc func buttonAction(sender:UITapGestureRecognizer) {
        print("removing plant from garden")
        for gardenPlant in gardenPlants {
            let label = sender.view as? UILabel
            if label?.text == gardenPlant.name {
                // delete plant
                let query = PFQuery(className: "Garden")
                query.whereKey("plantName", equalTo: gardenPlant.name)
                query.findObjectsInBackground { (objects, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.showAlert(title: "Error", message: "Could not delete this plant from the database. Please try again.")
                    } else if let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                            self.showAlert(title: "Plant removed", message: gardenPlant.name+" was successfully removed.")
                            gardenPlants = []
                            self.performSegue(withIdentifier: "toSettings", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
