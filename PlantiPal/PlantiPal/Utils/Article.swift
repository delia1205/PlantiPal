//
//  Article.swift
//  first try out on mac
//
//  Created by Delia on 24/03/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit
import Foundation

struct Response: Decodable {
    let response: ResponseData
}

struct ResponseData: Decodable {
    let numFound: Int
    let start: Int
    let maxScore: Double
    let docs: [Doc]
}

struct Doc: Decodable {
    let id: String
    let journal: String
    let eissn: String
    let publication_date: String
    let article_type: String
    let author_display: [String]
    let abstract: [String]
    let title_display: String
    let score: Double
}
