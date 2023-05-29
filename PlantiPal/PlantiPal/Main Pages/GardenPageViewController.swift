//
//  GardenPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class GardenPageViewController: UIViewController {
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var gardenIcon: UIImageView!
    @IBOutlet weak var scanIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: 115, width: 335, height: 460))
        self.view.addSubview(scrollView)
        
        if gardenPlants.count == 0 {
            //fetchGardenData()
            fetchData { (objects, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    for object in objects {
                        do{
                            let gardenPlantName = object["plantName"] as? String
                            let gardenPlantSpecies = object["plantSpecies"] as? String
                            let image: PFFileObject = object["plantPhoto"] as! PFFileObject
                            let data = try image.getData()
                            let gardenPlantPhoto = UIImage(data: data)
                            let daysToWater = object["wateringDays"] as! Int
                            let plant = GardenPlant(name: gardenPlantName!, species: gardenPlantSpecies!, photo: gardenPlantPhoto!, daysToWater: daysToWater)
                            gardenPlants.append(plant)
                        } catch {print(error)}
                    }
                    
                    print("Number of plants in garden of user: ", gardenPlants.count)
                    
                    if gardenPlants.count == 0 {
                        let text = "There are no plants in your garden. :("
                        let noPlantsLabel = UILabel(frame: CGRect(x: 20, y: 120, width: 335, height: 50))
                        noPlantsLabel.text = text
                        noPlantsLabel.textColor = UIColor(red: 0.89, green: 0.90, blue: 0.76, alpha: 1.00)
                        noPlantsLabel.textAlignment = .center
                        self.view.addSubview(noPlantsLabel)
                    }
                    else {
                        
                        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 110*gardenPlants.count))
                        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
                        
                        var buttons = [UIButton]()
                        var button : UIButton
                        
                        let paddingLeft: CGFloat = 10
                        let paddingRight: CGFloat = 10
                        
                        let x :CGFloat = 0.0
                        var y :CGFloat = 0.0
                        for i in 0...gardenPlants.count-1 {
                            button = UIButton(type: UIButtonType.system) as UIButton
                            button.frame = CGRect(x: x, y: y, width: 335.0, height: 100.0)
                            button.backgroundColor = UIColor(red: 0.89, green: 0.90, blue: 0.76, alpha: 1.00)
                            button.layer.cornerRadius = 5
                            button.setTitleColor(UIColor(red: 0.13, green: 0.15, blue: 0.15, alpha: 1.00), for: .normal)
                            let text = gardenPlants[i].name+"\nSpecies: "+gardenPlants[i].species
                            button.setTitle(text, for: .normal)
                            button.titleLabel?.textAlignment = .center
                            button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
                            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                            button.contentHorizontalAlignment = .center
                            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
                            button.addTarget(self, action: #selector(GardenPageViewController.buttonAction(sender:)), for: UIControlEvents.touchUpInside)
                            
                            contentView.addSubview(button)
                            
                            buttons.append(button)
                            y = y + 110
                        }
                        
                        scrollView.addSubview(contentView)
                        scrollView.contentSize = contentView.frame.size
                    }
                }
            }
        }
        else {
            
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 110*gardenPlants.count))
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
            
            var buttons = [UIButton]()
            var button : UIButton
            
            let paddingLeft: CGFloat = 10
            let paddingRight: CGFloat = 10
            
            let x :CGFloat = 0.0
            var y :CGFloat = 0.0
            for i in 0...gardenPlants.count-1 { button = UIButton(type: UIButtonType.system) as UIButton
                button.frame = CGRect(x: x, y: y, width: 335.0, height: 100.0)
                button.backgroundColor = UIColor(red: 0.89, green: 0.90, blue: 0.76, alpha: 1.00)
                button.layer.cornerRadius = 5
                button.setTitleColor(UIColor(red: 0.13, green: 0.15, blue: 0.15, alpha: 1.00), for: .normal)
                let text = gardenPlants[i].name+"\nSpecies: "+gardenPlants[i].species
                button.setTitle(text, for: .normal)
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
                button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                button.contentHorizontalAlignment = .center
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
                button.addTarget(self, action: #selector(GardenPageViewController.buttonAction(sender:)), for: UIControlEvents.touchUpInside)
                
                contentView.addSubview(button)
                
                buttons.append(button)
                y = y + 110
            }
            
            scrollView.addSubview(contentView)
            scrollView.contentSize = contentView.frame.size
        }
        
        
        // navbar
        let tapUser = UITapGestureRecognizer(target: self, action: #selector(self.userIconTapped))
        self.userIcon.addGestureRecognizer(tapUser)
        self.userIcon.isUserInteractionEnabled = true
        
        let tapHome = UITapGestureRecognizer(target: self, action: #selector(self.homeIconTapped))
        self.homeIcon.addGestureRecognizer(tapHome)
        self.homeIcon.isUserInteractionEnabled = true
        
        let tapGarden = UITapGestureRecognizer(target: self, action: #selector(self.gardenIconTapped))
        self.gardenIcon.addGestureRecognizer(tapGarden)
        self.gardenIcon.isUserInteractionEnabled = true
        
        let tapScan = UITapGestureRecognizer(target: self, action: #selector(self.scanIconTapped))
        self.scanIcon.addGestureRecognizer(tapScan)
        self.scanIcon.isUserInteractionEnabled = true
        
        let tapList = UITapGestureRecognizer(target: self, action: #selector(self.listIconTapped))
        self.listIcon.addGestureRecognizer(tapList)
        self.listIcon.isUserInteractionEnabled = true
    }
    
    @objc func buttonAction(sender:UIButton!) {
        spinner.startAnimating()
        print("Clicked on plant in garden")
        for plant in gardenPlants {
            let text = plant.name+"\nSpecies: "+plant.species
            if sender.titleLabel?.text == text {
                clickedPlant = plant
                print("clicked plant set: ", clickedPlant?.name as Any)
                break
            }
        }
        performSegue(withIdentifier: "goToClickedPlant", sender: self)
    }
    
    @objc func userIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("user icon tapped")
            performSegue(withIdentifier: "goToUser", sender: self)
        }
    }
    
    @objc func homeIconTapped(sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            self.spinner.startAnimating()
            print("home icon tapped")
            performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
    
    @objc func gardenIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("garden icon tapped")
            viewDidLoad()
        }
    }
    
    @objc func scanIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("scan new plant icon tapped")
            performSegue(withIdentifier: "goToScan", sender: self)
        }
    }
    
    @objc func listIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.spinner.startAnimating()
            print("list icon tapped")
            performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    
    func fetchData(completion: @escaping ([PFObject]?, Error?) -> Void) {
        let query = PFQuery(className: "Garden")
        query.whereKey("username", equalTo: loggedUser.user.username as Any)
        query.findObjectsInBackground { (objects, error) in
            completion(objects, error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
