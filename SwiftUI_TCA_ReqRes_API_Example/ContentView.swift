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
        NavigationView {
            ZStack {
                // User一覧
                // Listだとtransitionが効かないためScrollView+LazyVStackを使用
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(store.users, id: \.id) { user in
                            UserRow(user: user)
                            // 左からスライドイン + フェードイン
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .leading).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            Divider()
                        }
                    }
                }
                // 記事が追加されたときにスプリングアニメーションを適用
                .animation(.spring(duration: 1, bounce: 0.3), value: store.users)
                .navigationTitle("Users")
                .navigationSubtitle("SwiftUI TCA")
                
                // ローディング
                if store.isLoading {
                    ProgressView()
                        .scaleEffect(2.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
            // エラーアラート
            .alert(
                "エラー",
                isPresented: Binding(
                    get: { store.errorMessage != nil },
                    set: { if !$0 { store.send(.alertDismissed) } }
                ),
                actions: {
                    Button("OK") { store.send(.alertDismissed) }
                },
                message: {
                    Text(store.errorMessage ?? "")
                }
            )
        }
        // 画面表示時に記事取得
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: UserFeature.State()) {
        UserFeature()
    })
}


/*

 Button("button", action: {
     //store.send(.onAppear)
     // デバッグ用
     Task {
         do {
             let users = try await UserClient.liveValue.getUsers()
             print(users)
         } catch let error as UserError {
             print("❌ エラー: \(error.rawValue)")
         }
     }
     
     // デバッグ用
     Task {
         do {
             let users = try await UserClient.liveValue.getUser(1)
             print(users)
         } catch let error as UserError {
             print("❌ エラー: \(error.rawValue)")
         }
     }
      
 })
 
 */
