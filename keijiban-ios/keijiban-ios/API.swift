//
//  API.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/14.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import Foundation
import Moya

public enum ContributionAPI {
    case create(Contribution)
}

extension ContributionAPI: TargetType{
    public var baseURL: URL {
        return URL(string: "https://us-central1-peak-castle-197912.cloudfunctions.ne")!
    }
    
    public var path: String {
        switch self {
        case .create:
            return "/message"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .create(let contribution):
            return .requestJSONEncodable(contribution)
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .create:
            return "{\"contributer\":\"homahi\", \"body\":\"hello\"}".data(using:String.Encoding.utf8)!
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
