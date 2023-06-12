//
//  AddJournalEntryViewController.swift
//  PlantiPal
//
//  Created by Delia on 03/06/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class AddJournalEntryViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plantName.text = clickedPlant?.name
        plantSpecies.text = clickedPlant?.species
        headerLabel.text = "Add a new journal entry for " + (clickedPlant?.name)! + ": "
        
        textView.delegate = self 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNoteTapped(_ sender: Any) {
        let entryText = textView.text
        let journalObject = PFObject(className: "Journal")
        journalObject["username"] = loggedUser.user.username
        journalObject["plantName"] = clickedPlant?.name
        journalObject["journalEntry"] = entryText
        journalObject["entryDate"] = Date()
        journalObject.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                print("note added")
                self.displayAlertAndSegue(withTitle: "Note added", message: "The new journal entry for "+(clickedPlant?.name)!+" was added successfully.")
            }
            else {
                print("some error")
                print(error.debugDescription)
                self.displayAlertAndSegue(withTitle: "Error", message: "There was a problem while adding this journal entry. Please try again.")
            }
        }
        // print(entryText!)
    }
    
    func displayAlertAndSegue(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    notifAccess = true;
                } else {
                    notifAccess = false;
                }
            }
            
            self.performSegue(withIdentifier: "backToJournal", sender: self)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
