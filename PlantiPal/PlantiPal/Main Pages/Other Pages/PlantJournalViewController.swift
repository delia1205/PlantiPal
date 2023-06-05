//
//  PlantJournalViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/06/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class PlantJournalViewController: UIViewController {

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    @IBOutlet weak var plusIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plantName.text = clickedPlant?.name
        plantSpecies.text = clickedPlant?.species
        
        let scrollView = UIScrollView(frame: CGRect(x: 23, y: 135, width: 348, height: 520))
        self.view.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 600))
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        let textView = UIView(frame: CGRect(x:0, y:0, width: 335, height: 0))
        textView.tintColor = UIColor(red: 0.93, green: 0.94, blue: 0.85, alpha: 1.00)
        
        var index = 0
        var nextY: CGFloat = 0
        fetchData { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                if objects.count == 0 {
                    let noEntriesLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 335, height: 100))
                    noEntriesLabel.text = "You don't have any journal entries for this plant. Tap the plus sign to add a journal note."
                    noEntriesLabel.textColor = UIColor(red: 0.37, green: 0.19, blue: 0.14, alpha: 1.00)
                    noEntriesLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                    noEntriesLabel.numberOfLines = 3
                    
                    textView.addSubview(noEntriesLabel)
                }
                else {
                for object in objects {
                    index = index + 1
                    let journalEntryTitle = "Journal Entry"
                    let journalEntryDate = object["entryDate"] as! Date
                    let journalEntryText = object["journalEntry"] as! String
                    
                    let entryView = UIView(frame: CGRect(x:0, y: nextY, width: 335, height: 90))
                    
                    var entryText = journalEntryTitle + "\n"
                    let dateString = self.convertDateToString(date: journalEntryDate)
                    entryText = entryText + dateString
                    entryText = entryText + "\n" + journalEntryText
                    
                    let attributedText = NSMutableAttributedString(string: entryText)
                    let boldFontAttribute: [NSAttributedStringKey: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 20)
                    ]
                    let range = (entryText as NSString).range(of: journalEntryTitle)
                    attributedText.addAttributes(boldFontAttribute, range: range)
                    
                    let label = UILabel(frame: CGRect(x:0, y: 0, width: 335, height: CGFloat.greatestFiniteMagnitude))
                    label.numberOfLines = 0
                    label.lineBreakMode = NSLineBreakMode.byWordWrapping
                    label.attributedText = attributedText
                    label.textColor = UIColor(red: 0.37, green: 0.19, blue: 0.14, alpha: 1.00)
                    label.sizeToFit()
                    
                    entryView.addSubview(label)
                    textView.addSubview(entryView)
                    
                    nextY += 95
                }
                }
            }
        }
        textView.frame.size.height = nextY
        contentView.addSubview(textView)
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        let tapPlus = UITapGestureRecognizer(target: self, action: #selector(self.plusIconTapped))
        self.plusIcon.addGestureRecognizer(tapPlus)
        self.plusIcon.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(completion: @escaping ([PFObject]?, Error?) -> Void) {
        let query = PFQuery(className: "Journal")
        query.whereKey("username", equalTo: loggedUser.user.username as Any)
        query.whereKey("plantName", equalTo: clickedPlant?.name as Any)
        query.findObjectsInBackground { (objects, error) in
            completion(objects, error)
        }
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    @objc func plusIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "addEntry", sender: self)
        }
    }
    
    func customLabel(text: NSMutableAttributedString, size: CGFloat, nextY: CGFloat) -> UILabel {
        //print(nextY)
        let label = UILabel(frame: CGRect(x:0, y: nextY, width: 335, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.attributedText = text
        label.textColor = UIColor(red: 0.37, green: 0.19, blue: 0.14, alpha: 1.00)
        label.sizeToFit()
        
        return label
    }

}
