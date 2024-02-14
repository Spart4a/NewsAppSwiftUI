//
//  Article.swift
//  NewsAppSwiftUI
//
//  Created by Ivan on 06.11.2023..
//

import Foundation

struct Article: Codable, Equatable, Identifiable {
    let id = UUID()
    let source: Source
    let title: String
    let url: String
    let publishedAt: Date
    let author: String?
    let description: String?
    let urlToImage: String?
    
    enum CodingKeys: String, CodingKey {
        case source, title, url, publishedAt, author, description, urlToImage
    }
    
    var authorText: String {
        author ?? "N/A"
    }
    
    var descriptionText: String {
        description ?? "No description available"
    }
    
    var captionText: String {
        "\(source.name) ‧ \(Article.relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        urlToImage.flatMap(URL.init)
    }
    
    private static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    static func previewData() throws -> [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
}

struct Source: Codable, Equatable {
    let name: String
}

