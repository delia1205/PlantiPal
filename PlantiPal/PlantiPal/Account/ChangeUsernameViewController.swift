//
//  ChangeUsernameViewController.swift
//  PlantiPal
//
//  Created by Delia on 19/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class ChangeUsernameViewController: UIViewController {
    @IBOutlet weak var oldUsername: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    @IBOutlet weak var newUsername: PaddedTextField!
    
    @IBOutlet weak var confirmBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        oldUsername.delegate = self
        newUsername.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func changeUsernameConfirm(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.oldUsername.text!, password: self.passwordField.text!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                user?.setValue(self.newUsername.text!, forKey: "username")
                user?.saveInBackground()
                
                self.displayAlertAndSegue(withTitle: "Changed username succesfully", message: "You must log in again.")
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
