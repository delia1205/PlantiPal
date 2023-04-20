//
//  ClickedArticleViewController.swift
//  PlantiPal
//
//  Created by Delia on 19/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit

class ClickedArticleViewController: UIViewController {
    
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var copyBttn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var idDOI: UILabel!
    @IBOutlet weak var abstractText: UILabel!
    @IBOutlet weak var authorsList: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleTitle.text = stripHTMLTags(from: (clickedArticle?.title_display)!)
        idDOI.text = clickedArticle?.id
        abstractText.text = stripHTMLTags(from: (clickedArticle?.abstract.joined(separator: ", "))!)
        authorsList.text = stripHTMLTags(from: (clickedArticle?.author_display.joined(separator: ", "))!)
    }
    
    @IBAction func copyButtonClicked(_ sender: Any) {
        UIPasteboard.general.string = idDOI.text
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.spinner.startAnimating()
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    func stripHTMLTags(from string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
