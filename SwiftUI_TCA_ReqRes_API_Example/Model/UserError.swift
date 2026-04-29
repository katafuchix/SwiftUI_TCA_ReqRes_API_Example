//
//  UserError.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

enum UserError: String, Equatable, Error {
    case serverError = "Please check your internet connection  and try again!!!"
    case invalidUser = "The User doesn't exist, refresh and Try Again!!!"
    case invalidUrl =  "Internal Errror refresh and Try Again!!!"
    case internalError =  "Something went wrong refresh and Try Again!!!"
}
