//
//  UserFeature.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

import ComposableArchitecture
import Foundation
 
@Reducer
struct UserFeature {
    
    // MARK: - Dependency
    @Dependency(\.userClient) var userClient
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var users: [UserData] = []      // User一覧
        var isLoading = false             // ローディング中フラグ
        var errorMessage: String? = nil   // エラーメッセージ
    }
    
    // MARK: - Action
    enum Action: Equatable {
        case onAppear                                      // 画面表示時にUser取得
        case fetchUsers                                 // User取得
        case fetchResponse(Result<[UserData], UserError>) // User取得の結果
        case alertDismissed                                // エラーアラートを閉じた
    }
    
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // 画面表示時にUser取得を開始
                case .onAppear:
                    return .send(.fetchUsers )
     
                // 記事取得開始 → ローディング表示
                case .fetchUsers:
                    state.isLoading = true
                    state.errorMessage = nil
                    return .run { [userClient] send in
                        do {
                            let users = try await userClient.getUsers()
                            await send(.fetchResponse(.success(users)))
                        } catch let error as UserError {
                            await send(.fetchResponse(.failure(error)))
                        } catch {
                            await send(.fetchResponse(.failure(.serverError)))
                        }
                    }
                // 記事取得成功 → User一覧をStateにセット
                case .fetchResponse(.success(let users)):
                print(users)
                    state.users   = users
                    state.isLoading  = false
                    return .none
     
                // 記事取得失敗 → エラーメッセージをセット
                case .fetchResponse(.failure(let error)):
                    state.isLoading     = false
                    state.errorMessage  = error.localizedDescription
                    return .none
     
                // エラーアラートを閉じる
                case .alertDismissed:
                    state.errorMessage = nil
                    return .none
                }
            
        }
    }
}
