//
//  PlantDetailsViewController.swift
//  PlantiPal
//
//  Created by Delia on 19/05/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class PlantDetailsViewController: UIViewController {

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantSpecies: UILabel!
    @IBOutlet weak var journalIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantName.text = clickedPlant?.name
        plantSpecies.text = clickedPlant?.species
        
        let scrollView = UIScrollView(frame: CGRect(x: 23, y: 135, width: 348, height: 520))
        self.view.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 2550))
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        let image = clickedPlant?.photo
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x:0, y:0, width: 335, height: 335)
        imageView.contentMode = .scaleAspectFill
        
        let textView = UIView(frame: CGRect(x:0, y:350, width: 335, height: 2200))
        textView.tintColor = UIColor(red: 0.93, green: 0.94, blue: 0.85, alpha: 1.00)
        
        fetchData { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                for object in objects {
                    let descriptionText = object["description"] as! String
                    let usesText = object["uses"] as! String
                    let allergyText = object["allergy"] as! String
                    let childSafeText = object["childSafe"] as! String
                    let petsSafeText = object["petSafe"] as! String
                    let careDifficultyText = object["careDifficulty"] as! String
                    let originText = object["originCountry"] as! String
                    
                    let plantDetailsText = "Plant description:\n\n"+descriptionText+"\n\nPlant uses:\n\n"+usesText+"\n\nCan you be allergic to "+(clickedPlant?.name)!+" ?\n\n"+allergyText+"\n\nIs it safe to keep around children?\n\n"+childSafeText+"\n\nIs it safe to keep around pets?\n\n"+petsSafeText+"\n\nHow hard is it to care for?\n\n"+careDifficultyText+"\n\nPlant origin:\n\n"+originText
                    
                    let attributedText = NSMutableAttributedString(string: plantDetailsText)
                    
                    let boldFontAttribute: [NSAttributedStringKey: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 19)
                    ]
                    
                    let range1 = (plantDetailsText as NSString).range(of: "Plant description:")
                    attributedText.addAttributes(boldFontAttribute, range: range1)
                    let range2 = (plantDetailsText as NSString).range(of: "Plant uses:")
                    attributedText.addAttributes(boldFontAttribute, range: range2)
                    let range3 = (plantDetailsText as NSString).range(of: "Can you be allergic to "+(clickedPlant?.name)!+" ?")
                    attributedText.addAttributes(boldFontAttribute, range: range3)
                    let range4 = (plantDetailsText as NSString).range(of: "Is it safe to keep around children?")
                    attributedText.addAttributes(boldFontAttribute, range: range4)
                    let range5 = (plantDetailsText as NSString).range(of: "Is it safe to keep around pets?")
                    attributedText.addAttributes(boldFontAttribute, range: range5)
                    let range6 = (plantDetailsText as NSString).range(of: "How hard is it to care for?")
                    attributedText.addAttributes(boldFontAttribute, range: range6)
                    let range7 = (plantDetailsText as NSString).range(of: "Plant origin:")
                    attributedText.addAttributes(boldFontAttribute, range: range7)
                    
                    let plantDetailsLabel = self.customLabel(text: attributedText, size: 18)
                    
                    textView.addSubview(plantDetailsLabel)
                }
            }
        }
        contentView.addSubview(imageView)
        contentView.addSubview(textView)
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        let tapJournal = UITapGestureRecognizer(target: self, action: #selector(self.journalIconTapped))
        self.journalIcon.addGestureRecognizer(tapJournal)
        self.journalIcon.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func journalIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("journal icon tapped")
            performSegue(withIdentifier: "goToJournal", sender: self)
        }
    }
    
    func fetchData(completion: @escaping ([PFObject]?, Error?) -> Void) {
        let query = PFQuery(className: "PlantSpecies")
        query.whereKey("plantSpecies", equalTo: clickedPlant?.species as Any)
        query.findObjectsInBackground { (objects, error) in
            completion(objects, error)
        }
    }
    
    func customLabel(text: NSMutableAttributedString, size: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x:0, y: 0, width: 335, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.attributedText = text
        label.textColor = UIColor(red: 0.93, green: 0.94, blue: 0.85, alpha: 1.00)
        // label.font = label.font.withSize(size)
        label.sizeToFit()
        
        print(label.frame.height)
        return label
    }


}

