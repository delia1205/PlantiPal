//
//  ScanPlantPageViewController.swift
//  first try out on mac
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit

class ScanPlantPageViewController: UIViewController {

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
    
    @objc func userIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("user icon tapped")
            performSegue(withIdentifier: "goToUser", sender: self)
        }
    }
    
    @objc func homeIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
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
            viewDidLoad()
        }
    }
    
    @objc func listIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("list icon tapped")
            performSegue(withIdentifier: "goToList", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
