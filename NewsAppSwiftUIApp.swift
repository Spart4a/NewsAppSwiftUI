//
//  NewsAppSwiftUIApp.swift
//  NewsAppSwiftUI
//
//  Created by Ivan on 06.11.2023..
//

import SwiftUI

@main
struct XCANewsApp: App {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
                .preferredColorScheme(.dark) 
        }
    }
}
