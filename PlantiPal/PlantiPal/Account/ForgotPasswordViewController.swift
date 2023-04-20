//
//  ForgotPasswordViewController.swift
//  PlantiPal
//
//  Created by Delia on 19/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var confirmBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        PFUser.requestPasswordResetForEmail(inBackground: emailField.text!, block: { (success: Bool, error: Error?) -> Void in
            if (error != nil) {
                self.displayAlert(withTitle: "Error", message: "Try again.")
            }
            else {
                self.displayAlertAndSegue(withTitle: "Request sent", message: "We've sent you an email at " + self.emailField.text! + ". Proceed there to reset your password.")
            }
        })
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func displayAlertAndSegue(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // print("Ok button tapped")
            self.performSegue(withIdentifier: "goToHome", sender: self)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
