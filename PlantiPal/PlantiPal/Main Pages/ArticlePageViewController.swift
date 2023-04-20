//
//  ArticlePageViewController.swift
//  PlantiPal
//
//  Created by Delia on 20/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class ArticlePageViewController: UIViewController {
    
    var articlesTitles = [String]()
    var articles = [Doc]()
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var gardenIcon: UIImageView!
    @IBOutlet weak var scanIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    
    func getUsername() -> String {
        return loggedUser.user.username!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Logged user rn: ", getUsername())
        let titleString = "Hello, " + getUsername() + "!"
        self.pageTitle.text = titleString
        
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: 115, width: 335, height: 460))
        view.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 1100))
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        // articles
        callAPI()
        decodeAPI()
        sleep(4)
        
        print("Count of articles: ", articles.count)
        
        var buttons = [UIButton]()
        var button : UIButton
        
        let paddingLeft: CGFloat = 10
        let paddingRight: CGFloat = 10
        
        let x :CGFloat = 0.0
        var y :CGFloat = 0.0
        for i in 0...9 {
            button = UIButton(type: UIButtonType.system) as UIButton
            // x, y, width, height
            button.frame = CGRect(x: x, y: y, width: 335.0, height: 100.0)
            button.backgroundColor = UIColor(red: 0.26, green: 0.16, blue: 0.12, alpha: 1.00)
            button.layer.cornerRadius = 5
            button.setTitleColor(UIColor(red: 0.95, green: 0.91, blue: 0.86, alpha: 1.00), for: .normal)
            button.setTitle(articlesTitles[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
            button.addTarget(self, action: #selector(ArticlePageViewController.buttonAction(sender:)), for: UIControlEvents.touchUpInside)
            
            contentView.addSubview(button)
            
            buttons.append(button)
            y = y + 110
        }
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        
        // navbar
        let tapUser = UITapGestureRecognizer(target: self, action: #selector(self.userIconTapped))
        userIcon.addGestureRecognizer(tapUser)
        userIcon.isUserInteractionEnabled = true
        
        let tapHome = UITapGestureRecognizer(target: self, action: #selector(self.homeIconTapped))
        homeIcon.addGestureRecognizer(tapHome)
        homeIcon.isUserInteractionEnabled = true
        
        let tapGarden = UITapGestureRecognizer(target: self, action: #selector(self.gardenIconTapped))
        gardenIcon.addGestureRecognizer(tapGarden)
        gardenIcon.isUserInteractionEnabled = true
        
        let tapScan = UITapGestureRecognizer(target: self, action: #selector(self.scanIconTapped))
        scanIcon.addGestureRecognizer(tapScan)
        scanIcon.isUserInteractionEnabled = true
        
        let tapList = UITapGestureRecognizer(target: self, action: #selector(self.listIconTapped))
        listIcon.addGestureRecognizer(tapList)
        listIcon.isUserInteractionEnabled = true
    }
    
    @objc func buttonAction(sender:UIButton!) {
        print("Clicked on article")
        for article in articles {
            if sender.titleLabel?.text == stripHTMLTags(from: article.title_display) {
                clickedArticle = article
                print("clicked article set: ", clickedArticle?.id as Any)
                break
            }
        }
        performSegue(withIdentifier: "goToClickedArticle", sender: self)
    }
    
    @objc func userIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.spinner.startAnimating()
            print("user icon tapped")
            performSegue(withIdentifier: "goToSettings", sender: self)
        }
    }
    
    @objc func homeIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("home icon tapped")
            viewDidLoad()
        }
    }
    
    @objc func gardenIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("garden icon tapped")
            performSegue(withIdentifier: "goToGarden", sender: self)
        }
    }
    
    @objc func scanIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("scan new plant icon tapped")
            performSegue(withIdentifier: "goToScanNew", sender: self)
        }
    }
    
    @objc func listIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.spinner.startAnimating()
            print("list icon tapped")
            performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    
    func callAPI() {
        
        guard let url = URL(string: "https://api.plos.org/search?q=title:plants&wt=json") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let data = data, let _ = String(data: data, encoding: .utf8){
                print("json parsed")
            }
        }
        
        task.resume()
    }
    
    func decodeAPI() {
        guard let url = URL(string: "https://api.plos.org/search?q=title:plants&wt=json") else{return}

        let task = URLSession.shared.dataTask(with: url){
            data, response, error in

            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode(Response.self, from: data)

                    var i = 0
                    while (i<10)
                    {
                        let article = tasks.response.docs[i]
                        let str = self.stripHTMLTags(from: tasks.response.docs[i].title_display)
                        //print(str)
                        self.articlesTitles.append(str)
                        self.articles.append(article)
                        i = i+1
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()

    }

    
    func stripHTMLTags(from string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
