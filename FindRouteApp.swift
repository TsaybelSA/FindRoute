//
//  FindRouteApp.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 08.04.2022.
//

import SwiftUI

@main
struct FindRouteApp: App {
    var body: some Scene {
		let data = SearchData()
        WindowGroup {
            ContentView()
				.environmentObject(data)
        }
    }
}
