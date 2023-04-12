//
//  SignUpViewController.swift
//  first try out on mac
//
//  Created by Delia on 17/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameSignUp: PaddedTextField!
    @IBOutlet weak var passwordSignUp: PaddedTextField!
    @IBOutlet weak var confPasswordSignUp: PaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameSignUp.delegate = self
        passwordSignUp.delegate = self
        confPasswordSignUp.delegate = self
    }
    
    @IBOutlet weak var LogInFromSignUp:UIButton!
    @IBAction func LogInFromSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogInFromSignUp", sender: self)
    }
    
    @IBOutlet weak var SignUpController: UIButton!
    @IBAction func SignUpController(_ sender: UIButton) {
        let user = PFUser()
        if (self.passwordSignUp.text == self.confPasswordSignUp.text) {
        user.username = self.usernameSignUp.text
        user.password = self.passwordSignUp.text
        
        user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                self.displayAlert(withTitle: "Error", message: error.localizedDescription)
            } else {
                self.displayAlert(withTitle: "Success", message: "Account has been successfully created. You can log in now.")
            }
        }
        }
        else {
            self.displayAlert(withTitle: "Error", message: "Passwords provided don't match.")
        }
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
