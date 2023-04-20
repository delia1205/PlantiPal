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
        // testParseConnection()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func testParseConnection(){
        let myObj = PFObject(className:"FirstClass")
        myObj["message"] = "Hey ! First message from Swift. Parse is now connected"
        myObj.saveInBackground { (success, error) in
            if(success){
                print("You are connected!")
            }else{
                print("An error has occurred!")
            }
        }
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

