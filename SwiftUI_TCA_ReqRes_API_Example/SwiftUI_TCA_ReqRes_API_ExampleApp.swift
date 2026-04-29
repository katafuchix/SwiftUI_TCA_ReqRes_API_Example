//
//  SwiftUI_TCA_ReqRes_API_ExampleApp.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftUI_TCA_ReqRes_API_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: UserFeature.State()) {
                    UserFeature()
                }
            )
        }
    }
}
