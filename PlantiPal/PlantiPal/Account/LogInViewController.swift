//
//  LogInViewController.swift
//  first try out on mac
//
//  Created by Delia on 12/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameLogIn: PaddedTextField!
    @IBOutlet weak var passwordLogIn: PaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLogIn.delegate = self
        passwordLogIn.delegate = self
    }
    
    @IBOutlet weak var LogInController: UIButton!
    
    @IBOutlet weak var SignUpFromLogIn:UIButton!
    @IBAction func SignUpFromLogIn(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUpFromLogIn", sender: self)
    }
    
    @IBAction func LogInController(_ sender: UIButton) {
        PFUser.logInWithUsername(inBackground: self.usernameLogIn.text!, password: self.passwordLogIn.text!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                loggedUser.setUser(user: user!)
                
                self.displayAlertAndSegue(withTitle: "Login Successful", message: "")
            }
            else {
                self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func displayAlertAndSegue(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // print("Ok button tapped")
            self.performSegue(withIdentifier: "goToArticlePage", sender: self)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true)
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
