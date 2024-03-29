//
//  SettingsPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 23/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class SettingsPageViewController: UIViewController {

    @IBOutlet weak var logOutBttn: UIButton!
    @IBOutlet weak var accountDetails: UIButton!
    @IBOutlet weak var gardenEdit: UIButton!
    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var gardenIcon: UIImageView!
    @IBOutlet weak var scanIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navbar
        let tapUser = UITapGestureRecognizer(target: self, action: #selector(self.userIconTapped))
        userIcon.addGestureRecognizer(tapUser)
        userIcon.isUserInteractionEnabled = true
        
        let tapHome = UITapGestureRecognizer(target: self, action: #selector(self.homeIconTapped))
        homeIcon.addGestureRecognizer(tapHome)
        homeIcon.isUserInteractionEnabled = true
        
        let tapGarden = UITapGestureRecognizer(target: self, action: #selector(self.gardenIconTapped))
        gardenIcon.addGestureRecognizer(tapGarden)
        gardenIcon.isUserInteractionEnabled = true
        
        let tapScan = UITapGestureRecognizer(target: self, action: #selector(self.scanIconTapped))
        scanIcon.addGestureRecognizer(tapScan)
        scanIcon.isUserInteractionEnabled = true
        
        let tapList = UITapGestureRecognizer(target: self, action: #selector(self.listIconTapped))
        listIcon.addGestureRecognizer(tapList)
        listIcon.isUserInteractionEnabled = true
    }

    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
        loggedUser = Main()
        gardenPlants = []
        articlesTitles = []
        articles = []
        plants = []
        plantNames = []
        
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set("", forKey: "objectId")
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "createdAt")
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    
    @IBAction func gardenDetailsPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEditGarden", sender: self)
    }
    
    @IBAction func accountDetailsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAccDetails", sender: self)
    }
    
    @IBAction func aboutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAbout", sender: self)
    }
    
    @objc func userIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("user icon tapped")
            viewDidLoad()
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
            performSegue(withIdentifier: "goToGarden", sender: self)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
