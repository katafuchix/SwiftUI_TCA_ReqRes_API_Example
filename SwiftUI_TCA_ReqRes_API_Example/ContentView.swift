//
//  ContentView.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @Bindable var store: StoreOf<UserFeature>
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("button", action: {
                print("tap")
                //store.send(.onAppear)
                
                /*
                // デバッグ用
                Task {
                    do {
                        let users = try await UserClient.liveValue.getUsers()
                        print(users)
                    } catch let error as UserError {
                        print("❌ エラー: \(error.rawValue)")
                    }
                }
                 */
            })
            
        }
        .padding()
        .onAppear {
            //store.send(.onAppear)
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: UserFeature.State()) {
        UserFeature()
    })
}
