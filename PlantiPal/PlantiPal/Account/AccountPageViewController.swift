//
//  AccountPageViewController.swift
//  first try out on mac
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

class AccountPageViewController: UIViewController {
    
    @IBOutlet weak var backBttn: UIButton!
    
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var createdAtText: UILabel!
    
    func getUsername() -> String {
        return loggedUser.user.username!
    }
    
    func getCreatedAtDate() -> String {
        let date = loggedUser.user.createdAt!
        return date.toString(dateFormat: "dd-MMM-yyyy")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userString = getUsername()
        self.usernameText.text = userString
        
        let createdAtDateString = getCreatedAtDate()
        self.createdAtText.text = createdAtDateString
    }
    
    @IBAction func backToSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "BackToSettings", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
