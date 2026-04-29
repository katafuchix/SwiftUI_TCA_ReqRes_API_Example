//
//  UserFeatureTests.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/30.
//

import ComposableArchitecture
import Testing
@testable import SwiftUI_TCA_ReqRes_API_Example
internal import Foundation

@MainActor
struct UserFeatureTests {
 
    // MARK: - テスト用のダミーデータ
    let dummyUsers = [
        UserData(id: 1, email: "test1@example.com", firstName: "Test1", lastName: "User1", avatar: "https://example.com/avatar1.jpg"),
        UserData(id: 2, email: "test2@example.com", firstName: "Test2", lastName: "User2", avatar: "https://example.com/avatar2.jpg"),
        UserData(id: 3, email: "test3@example.com", firstName: "Test3", lastName: "User3", avatar: "https://example.com/avatar3.jpg")
    ]
 
    // UserClientのモック（getUserとgetUsers両方必要）
    func mockClient(users: [UserData]) -> UserClient {  // ← 関数の定義
        return UserClient(                              // ← UserClientのインスタンスを生成して返す
            getUser: { _ in users.first! },
            getUsers: { users }
        )
    }
 
    func mockClientWithError(error: UserError) -> UserClient {
        return UserClient(
            getUser: { _ in throw error },
            getUsers: { throw error }
        )
    }
    
    // MARK: - 画面表示テスト
 
    @Test
    func onAppear_User取得が開始される() async throws {
        let dummyUsers = self.dummyUsers
        let store = TestStore(initialState: UserFeature.State()) {
            UserFeature()
        } withDependencies: {
            $0.userClient = mockClient(users: dummyUsers)
        }
 
        // 画面表示 → fetchUsersが発火する
        await store.send(.onAppear)
 
        // fetchUsersのActionを受け取る
        await store.receive(\.fetchUsers) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // User取得成功
        await store.receive(\.fetchResponse.success) {
            $0.users     = dummyUsers
            $0.isLoading = false
        }
    }
 
    // MARK: - User取得テスト
 
    @Test
    func fetchUsers_取得成功() async throws {
        let dummyUsers = self.dummyUsers
        let store = TestStore(initialState: UserFeature.State()) {
            UserFeature()
        } withDependencies: {
            // ダミーのUserを返すモックを注入
            $0.userClient = mockClient(users: dummyUsers)
        }
 
        // User取得開始 → ローディング開始
        await store.send(.fetchUsers) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // User取得成功 → usersにセットされる
        await store.receive(\.fetchResponse.success) {
            $0.users     = dummyUsers
            $0.isLoading = false
        }
    }
 
    @Test
    func fetchUsers_サーバーエラー() async throws {
        let store = TestStore(initialState: UserFeature.State()) {
            UserFeature()
        } withDependencies: {
            // サーバーエラーを返すモックを注入
            $0.userClient = mockClientWithError(error: .serverError)
        }
 
        await store.send(.fetchUsers) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // エラーが返ってくる → errorMessageがセットされる
        await store.receive(\.fetchResponse.failure) {
            $0.isLoading    = false
            $0.errorMessage = UserError.serverError.localizedDescription
        }
    }
 
    @Test
    func fetchUsers_無効なUser() async throws {
        let store = TestStore(initialState: UserFeature.State()) {
            UserFeature()
        } withDependencies: {
            $0.userClient = mockClientWithError(error: .invalidUser)
        }
 
        await store.send(.fetchUsers) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        await store.receive(\.fetchResponse.failure) {
            $0.isLoading    = false
            $0.errorMessage = UserError.invalidUser.localizedDescription
        }
    }
 
    @Test
    func fetchUsers_取得結果が空() async throws {
        let store = TestStore(initialState: UserFeature.State()) {
            UserFeature()
        } withDependencies: {
            // 空配列を返すモックを注入
            $0.userClient = UserClient(
                getUser: { _ in throw UserError.invalidUser  },
                getUsers: { [] }
            )
        }
 
        await store.send(.fetchUsers) {
            $0.isLoading    = true
            $0.errorMessage = nil
        }
 
        // 空配列が返ってくる → usersが空のまま
        await store.receive(\.fetchResponse.success) {
            $0.users     = []
            $0.isLoading = false
        }
    }
 
    // MARK: - エラーアラートテスト
 
    @Test
    func alertDismissed_エラーメッセージが消える() async throws {
        // エラーが表示されている状態からスタート
        let initialState = UserFeature.State(
            users:        [],
            isLoading:    false,
            errorMessage: UserError.serverError.rawValue
        )
 
        let store = TestStore(initialState: initialState) {
            UserFeature()
        }
 
        // アラートを閉じる → errorMessageがnilになる
        await store.send(.alertDismissed) {
            $0.errorMessage = nil
        }
    }
}
