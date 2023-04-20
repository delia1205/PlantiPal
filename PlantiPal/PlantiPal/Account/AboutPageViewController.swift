//
//  AboutPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {
    
    @IBOutlet weak var backBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backToSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "BackToSettings", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
