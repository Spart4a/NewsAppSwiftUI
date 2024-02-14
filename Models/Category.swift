//
//  Category.swift
//  NewsAppSwiftUI
//
//  Created by Ivan on 06.11.2023..
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case everything
    
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
