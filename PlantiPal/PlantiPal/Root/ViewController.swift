//
//  ViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var LogInBttnPressed:UIButton!
    @IBAction func LogInBttnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogIn", sender: self)
    }
    
    @IBOutlet weak var SignUpBttnPressed:UIButton!
    @IBAction func SignUpBttnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

