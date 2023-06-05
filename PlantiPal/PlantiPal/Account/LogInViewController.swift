//
//  LogInViewController.swift
//  PlantiPal
//
//  Created by Delia on 12/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameLogIn: PaddedTextField!
    @IBOutlet weak var passwordLogIn: PaddedTextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLogIn.delegate = self
        passwordLogIn.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            print("already logged in")
            // loggedUser = UserDefaults.standard.object(forKey: "loggedUser") as! Main
            loggedUser.user.objectId = UserDefaults.standard.string(forKey: "objectId")
            loggedUser.user.username = UserDefaults.standard.string(forKey: "username")
            loggedUser.user.password = UserDefaults.standard.string(forKey: "password")
            loggedUser.user.email = UserDefaults.standard.string(forKey: "email")
            loggedUser.createdAt = UserDefaults.standard.string(forKey: "createdAt")!
            displayAlertAndSegue(withTitle: "Already logged in", message: "")
        }
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
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(loggedUser.user.objectId, forKey: "objectId")
                UserDefaults.standard.set(loggedUser.user.username, forKey: "username")
                UserDefaults.standard.set(loggedUser.user.password, forKey: "password")
                UserDefaults.standard.set(loggedUser.user.email, forKey: "email")
                let date = loggedUser.user.createdAt
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/YYYY"
                let dateString = dateFormatter.string(from: date!)
                print("CREATED AT DATE STRING: ", dateString)
                UserDefaults.standard.set(dateString, forKey: "createdAt")
                loggedUser.createdAt = dateString
                
                self.displayAlertAndSegue(withTitle: "Login Successful", message: "")
            }
            else {
                self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func displayAlertAndSegue(withTitle title: String, message: String) {
        self.spinner.startAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    notifAccess = true;
                } else {
                    notifAccess = false;
                }
            }
            
            self.performSegue(withIdentifier: "goToArticlePage", sender: self)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true)
        //self.spinner.stopAnimating()
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    func stripHTMLTags(from string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
