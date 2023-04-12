//
//  ListPageViewController.swift
//  first try out on mac
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Foundation

class ListPageViewController: UIViewController {
    
    var plantNames = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var gardenIcon: UIImageView!
    @IBOutlet weak var scanIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: CGRect(x: 10, y: 145, width: 350, height: 430))
        view.addSubview(scrollView)
        
        decodeAPI()
        sleep(4)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 55*plantNames.count))
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0)

        print("NUMBER OF PLANT NAMES: " , plantNames.count)
        plantNames.sort()
        
        var buttons = [UIButton]()
        var button : UIButton
        
        let paddingLeft: CGFloat = 10
        let paddingRight: CGFloat = 10
        
        let x :CGFloat = 0.0
        var y :CGFloat = 0.0
        for i in 0...plantNames.count-1 {
            button = UIButton(type: UIButtonType.system) as UIButton
            button.frame = CGRect(x: x, y: y, width: 350.0, height: 50.0)
            button.backgroundColor = UIColor.white.withAlphaComponent(0)
            button.setTitleColor(UIColor(red: 0.18, green: 0.13, blue: 0.12, alpha: 1.00), for: .normal)
            button.setTitle(plantNames[i], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
            button.addTarget(self, action: #selector(ListPageViewController.buttonAction(sender:)), for: UIControlEvents.touchUpInside)
            
            contentView.addSubview(button)
            
            buttons.append(button)
            y = y + 55
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

    @objc func buttonAction(sender:UIButton!)
    {
        print("Button tapped")
    }

    @objc func userIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("user icon tapped")
            performSegue(withIdentifier: "goToUser", sender: self)
        }
    }
    
    @objc func homeIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("home icon tapped")
            performSegue(withIdentifier: "goToHome", sender: self)
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
            performSegue(withIdentifier: "goToScan", sender: self)
        }
    }
    
    @objc func listIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("list icon tapped")
            viewDidLoad()
        }
    }
    
    func decodeAPI() {
        guard let url = URL(string: "https://api.inaturalist.org/v1/observations?taxon_id=47126&order_by=desc&order=desc&per_page=80&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()
            
            if let data = data{
                do{
                    let tasks = try decoder.decode(Result.self, from: data)
                    
                    var i = 0
                    while (i<80)
                    {
                        let str = tasks.results[i].taxon.name
                        let plantName = str
                        //print(plantName)
                        if !self.plantNames.contains(plantName) {
                            self.plantNames.append(plantName)
                        }
                        i = i+1
                    }
                }catch{
                    print(error)
                }
            }
        }

        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
