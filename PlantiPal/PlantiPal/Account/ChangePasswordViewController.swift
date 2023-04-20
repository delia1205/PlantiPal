//
//  ChangePasswordViewController.swift
//  PlantiPal
//
//  Created by Delia on 19/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var usernameFiled: PaddedTextField!
    @IBOutlet weak var oldPassword: PaddedTextField!
    @IBOutlet weak var newPassword: PaddedTextField!
    @IBOutlet weak var confirmBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameFiled.delegate = self
        oldPassword.delegate = self
        newPassword.delegate = self
    }
    
    @IBAction func changePasswordConfirm(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: self.usernameFiled.text!, password: self.oldPassword.text!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                user?.setValue(self.newPassword.text!, forKey: "password")
                user?.saveInBackground()
                
                self.displayAlertAndSegue(withTitle: "Changed password succesfully", message: "You must log in again.")
            }
            else {
                self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
            }
        }
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
