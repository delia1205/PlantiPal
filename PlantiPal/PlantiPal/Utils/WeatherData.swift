//
//  WeatherData.swift
//  PlantiPal
//
//  Created by Delia on 04/06/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit

struct WeatherData: Decodable {
    let description: String
    let resolvedAddress: String
    let days: [WeatherDays]
    let currentConditions: Conditions
}

struct Conditions: Decodable {
    let sunrise: String
    let sunset: String
}

struct WeatherDays: Decodable {
    let datetime: String
    let tempmax: Float
    let tempmin: Float
    let temp: Float
    let feelslike: Float
    let description: String
    let snow: Float
}
