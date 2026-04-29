//
//  UserAPI.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

import Foundation

// MARK: - UserAPI
// APIエンドポイントをenumで定義するRouterパターン
enum UserAPI {
    case getUser(id: Int)
    case getUsers
}
 
extension UserAPI {
 
    // ベースURL
    private var baseURL: URL { URL(string: "https://reqres.in/api/")! }
 
    // エンドポイントのパス
    private var path: String {
        switch self {
        case .getUser(let id): return "users/\(id)"
        case .getUsers: return "users"
        }
    }
 
    // HTTPメソッド
    private var method: String { "GET" }
 
    // ヘッダー
    private var headers: [String: String] {
        return ["Content-Type": "application/json", "x-api-key": Constants.api_key]
    }
 
    // URLRequestに変換
    func asURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}
