//
//  global.swift
//  PlantiPal
//
//  Created by Delia on 20/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Parse

class Main {

    var user = PFUser()
    
    func setUser(user: PFUser) {
        self.user = user
    }

}

var loggedUser = Main()

var gardenPlants = [GardenPlant]()

var articlesTitles = [String]()
var articles = [Doc]()

var plants = [PlantData]()
var plantNames = [String]()
