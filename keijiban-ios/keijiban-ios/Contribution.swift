//
//  Contribution.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/14.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import Foundation

public struct Contribution: Codable {
    let id: Int
    let contributor: String
    let body: String
}

public struct ContributionRequest: Codable {
    let contributor: String
    let body: String
}

public struct UpdateContributionRequest: Codable {
    let body: String
}
