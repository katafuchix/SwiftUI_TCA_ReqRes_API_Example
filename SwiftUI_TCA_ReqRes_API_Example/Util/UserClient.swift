//
//  UserClient.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

import Foundation
import ComposableArchitecture
 
// MARK: - UserClient
// TCAのDependencyとして定義することでテスト時にモックに差し替えられる
struct UserClient {
    var getUser: (_ id: Int) async throws -> UserData
    var getUsers: () async throws -> [UserData]
}
 
// MARK: - DependencyKey
extension UserClient: DependencyKey {
    // 本番用の実装
    static let liveValue = UserClient(
        getUser: { id in
            let request = UserAPI.getUser(id: id).asURLRequest()
            let (data, response) = try await URLSession.shared.data(for: request)
 
            // ステータスコードでエラーハンドリング
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    break
                case 404:
                    throw UserError.invalidUser
                case 500..<599:
                    throw UserError.serverError
                default:
                    throw UserError.internalError
                }
            }
 
            // JSONデコード
            guard let singleUser = try? JSONDecoder().decode(SingleUser.self, from: data) else {
                throw UserError.internalError
            }
 
            // キャッシュとクッキーをクリア
            await URLSession.shared.reset()
 
            return singleUser.data
        },
        getUsers: { 
            let request = UserAPI.getUsers.asURLRequest()
            let (data, response) = try await URLSession.shared.data(for: request)
 
            // ステータスコードでエラーハンドリング
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    break
                case 404:
                    throw UserError.invalidUser
                case 500..<599:
                    throw UserError.serverError
                default:
                    throw UserError.internalError
                }
            }
 
            // JSONデコード
            guard let users = try? JSONDecoder().decode(Users.self, from: data) else {
                throw UserError.internalError
            }
 
            // キャッシュとクッキーをクリア
            await URLSession.shared.reset()
 
            return users.data
        }
    )
 
    // テスト用の実装
    static let testValue = UserClient(
        getUser: { _ in
            UserData(
                id: 1,
                email: "test@example.com",
                firstName: "Test",
                lastName: "User",
                avatar: "https://example.com/avatar.jpg"
            )
        },
        getUsers: {
            [
                UserData(
                    id: 1,
                    email: "test@example.com",
                    firstName: "Test",
                    lastName: "User",
                    avatar: "https://example.com/avatar.jpg"
                ),
                UserData(
                    id: 2,
                    email: "test@example.com",
                    firstName: "Test",
                    lastName: "User",
                    avatar: "https://example.com/avatar.jpg"
                )
            ]
        }
    )
}
 
// MARK: - DependencyValues
extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
