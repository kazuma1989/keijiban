//
//  ViewModel.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/16.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class ViewModel {
    
    let contribution: Observable<[Contribution]>

    init() {
        let provider = MoyaProvider<ContributionAPI>(stubClosure: {
            (_: ContributionAPI) -> Moya.StubBehavior in
            return .never
        })
        
        contribution = Observable.just(1).flatMap {_ in
           return provider.rx.request(.list).debug("request").retry(3).map([Contribution].self)

        }
    }
}
