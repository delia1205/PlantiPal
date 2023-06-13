//
//  ScanPlantPageViewController.swift
//  PlantiPal
//
//  Created by Delia on 02/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Foundation

class ScanPlantPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var gardenIcon: UIImageView!
    @IBOutlet weak var scanIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var speciesField: UILabel!
    @IBOutlet weak var learnMoreBttn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.isHidden = true
        speciesField.isHidden = true
        learnMoreBttn.isHidden = true
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.13, green: 0.15, blue: 0.15, alpha: 1.00).cgColor
        
        imagePicker.delegate = self
        
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
            viewDidLoad()
        }
    }
    
    @objc func listIconTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.spinner.startAnimating()
            print("list icon tapped")
            performSegue(withIdentifier: "goToList", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showImagePicker() {
        let alertController = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available.")
        }
    }
    
    func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            self.spinner.startAnimating()
            self.identifyPlantPlantiPalModel(image: selectedImage) { scientificName, probabilityScore in
                if let name = scientificName,
                    let score = probabilityScore {
                    if score * 100 > 95 {
                        print("Identified plant species: \(name)")
                        DispatchQueue.main.async {
                            self.imageView.image = selectedImage
                            self.imageView.contentMode = .scaleAspectFill
                            self.textField.isHidden = false
                            self.learnMoreBttn.isHidden = false
                            self.speciesField.isHidden = false
                            self.speciesField.text = identifiedPlant?.species
                            self.spinner.stopAnimating()
                        }
                    }
                    else {
                        self.identifyPlant(image: selectedImage) { scientificName in
                            if let name = scientificName {
                                print("Identified plant species: \(name)")
                                DispatchQueue.main.async {
                                    self.imageView.image = selectedImage
                                    self.imageView.contentMode = .scaleAspectFill
                                    self.textField.isHidden = false
                                    self.learnMoreBttn.isHidden = false
                                    self.speciesField.isHidden = false
                                    self.speciesField.text = identifiedPlant?.species
                                    self.spinner.stopAnimating()
                                }
                            }
                        }
                    }
                }
                else {
                    print("Plant identification failed. Try again later.")
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.speciesField.isHidden = false
                        self.speciesField.text = "Plant identification failed."
                    }
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        showImagePicker()
    }
    
    func identifyPlant(image: UIImage, completion: @escaping (String?) -> Void) {
        print("identifying plant...")
        let apiUrl = "https://my-api.plantnet.org/v2/identify/{PROJECT}"
        let apiKey = "2b10hb7wHHm7bNK4UjCHrv0W"
        let encodedUrl = apiUrl.replacingOccurrences(of: "{PROJECT}", with: "best") + "?api-key=" + apiKey
        
        guard let url = URL(string: encodedUrl) else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let lineBreak = "\r\n"
        var body = Data()
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"images\"; filename=\"image.jpeg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let results = json["results"] as? [[String: Any]],
                        let bestMatch = results.first,
                        let species = bestMatch["species"] as? [String: Any],
                        var scientificName = species["scientificName"] as? String {
                        if scientificName.starts(with: "Aloe") {
                            scientificName = "Aloe Vera"
                        }
                        if scientificName.starts(with: "Hibiscus") {
                            scientificName = "Hibiscus"
                        }
                        if scientificName.starts(with: "Tulipa") {
                            scientificName = "Tulip"
                        }
                        if scientificName.starts(with: "Rosa") {
                            scientificName = "Rose"
                        }
                        identifiedPlant = IdentificationPlant(species: scientificName, photo: image)
                        print("plant identified: ", scientificName)
                        completion(scientificName)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func identifyPlantPlantiPalModel(image: UIImage, completion: @escaping (String?, Float?) -> Void) {
        let Url = "http://192.168.100.156:5000/predict"
        
        guard let url = URL(string: Url) else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        let lineBreak = "\r\n"
        var body = Data()
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        body.append("--\(boundary + lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            if let data = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let result = json["predicted_class"] as? Int,
                        let plantName = json["predicted_label"] as? String,
                        let probability = json["predicted_probability"] as? Float {
                        identifiedPlant = IdentificationPlant(species: plantName, photo: image)
                        print(result, " plant identified: ", plantName, " with probability score: ", probability * 100)
                        completion(plantName, probability)
                    } else {
                        completion(nil, nil)
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
}
