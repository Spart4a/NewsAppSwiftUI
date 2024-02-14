//
// NewsAPI.swift
// NewsAppSwiftUI
//
// Created by Ivan on 06.11.2023..
//

import Foundation

struct NewsAPI {
    
    static let shared = NewsAPI()
    private init() {}
    
    private let apiKey = "56bffe626d4f43d5a6d167b9dd6854fa"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetch(from category: Category) async throws -> [Article] {
        let url: URL
        switch category {
        case .general:
            url = generateNewsURL(from: category)
        case .everything:
            url = generateEverythingURL(query: "default", page: 1)
        }
        return try await fetchArticles(from: url)
    }
    
    private func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw generateError(description: "HTTP Error: \(httpResponse.statusCode)")
        }
        
        let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
        if apiResponse.status == "ok" {
            return apiResponse.articles ?? []
        } else {
            throw generateError(description: apiResponse.message ?? "An error occurred")
        }
    }
    
    private func generateEverythingURL(query: String, page: Int) -> URL {
        var components = URLComponents(string: "https://newsapi.org/v2/everything")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: "10"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        return components.url!
    }
    
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "country=us"
        url += "&apiKey=\(apiKey)"
        return URL(string: url)!
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    func search(for query: String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
}
