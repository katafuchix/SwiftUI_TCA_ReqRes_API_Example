//
//  UserRow.swift
//  SwiftUI_TCA_ReqRes_API_Example
//
//  Created by cano on 2026/04/29.
//

import SwiftUI

struct UserRow: View {
    let user: UserData
 
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarURL,scale: 0.5){ image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }.frame(width: 50, height: 50)
            
            VStack {
                Text(user.fullName)
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
