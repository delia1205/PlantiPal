//
//  PlantList.swift
//  first try out on mac
//
//  Created by Delia on 06/04/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit

struct Result: Decodable {
    let results: [Plant]
}

struct Plant: Decodable {
    let taxon: PlantData
}

struct PlantData: Decodable {
    let name: String
    let id: Int
    let wikipedia_url: String?
}
