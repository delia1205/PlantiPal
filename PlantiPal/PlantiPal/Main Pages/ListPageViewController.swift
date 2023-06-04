//
//  ListPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Foundation

class ListPageViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var gardenIcon: UIImageView!
    @IBOutlet weak var scanIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    
    var plantFilteredNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.borderWidth = 0
        
        if plantNames.count == 0 {
            decodeAPI()
            sleep(6)
            print("NUMBER OF PLANT NAMES: " , plantNames.count)
            plantNames.sort()
        }
        plantFilteredNames = plantNames
        
        
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
    
    @objc func userIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("user icon tapped")
            performSegue(withIdentifier: "goToUser", sender: self)
        }
    }
    
    @objc func homeIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.spinner.startAnimating()
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
                        let plant = tasks.results[i].taxon
                        let str = tasks.results[i].taxon.name
                        let plantName = str
                        //print(plantName)
                        if !plantNames.contains(plantName) {
                            plantNames.append(plantName)
                            plants.append(plant)
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
    
    @objc func buttonAction(_ sender:UITapGestureRecognizer)
    {
        print("Plant button tapped")
        for plant in plants {
            let tapLocation = sender.location(in: self.searchTableView)
            if let tapIndexPath = self.searchTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.searchTableView.cellForRow(at: tapIndexPath) {
                    if tappedCell.textLabel?.text == plant.name {
                        if plant.wikipedia_url != nil {
                            UIApplication.shared.open(NSURL(string: plant.wikipedia_url!)! as URL, options: [:], completionHandler: nil)
                            print(plant.wikipedia_url!)
                            break;
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ListPageViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setValue("Cancel", forKey: "cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        plantFilteredNames = plantNames
        
        if searchText.isEmpty == false {
            plantFilteredNames = plantNames.filter({ $0.contains(searchText) })
        }
        
        searchTableView.reloadData()
    }
}

extension ListPageViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantFilteredNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        cell.textLabel?.text = plantFilteredNames[indexPath.row]
        let tapCell = UITapGestureRecognizer(target: self, action: #selector(self.buttonAction))
        cell.addGestureRecognizer(tapCell)
        cell.isUserInteractionEnabled = true
        return cell
    }
}
