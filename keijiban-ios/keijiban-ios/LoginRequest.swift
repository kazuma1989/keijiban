//
//  LoginRequest.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/21.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import Foundation

public struct LoginRequest: Codable {
    let id: String
    let password: String
}

public struct LoginResponse: Codable {
    let token: String
}
