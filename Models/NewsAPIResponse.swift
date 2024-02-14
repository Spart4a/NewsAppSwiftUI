//
//  NewsAPIResponse.swift
//  NewsAppSwiftUI
//
//  Created by Ivan on 06.11.2023..
//

import Foundation

struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
