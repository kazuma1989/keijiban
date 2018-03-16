//
//  ViewModel.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/14.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class SendViewModel {
    
    let send: Observable<Response>
    
    init (
        input:(
        contributer: Driver<String>,
        body: Driver<String>,
        sendTapped: Observable<Void>
        
        )
        ){
        let contribution = Driver.combineLatest(input.contributer,input.body) {
            (contributor: $0, body: $1)
        }
        
        let provider = MoyaProvider<ContributionAPI>(stubClosure: { (_: ContributionAPI) -> Moya.StubBehavior in
            return .never
        })
        
        send = input.sendTapped.debug("tapped")
            .withLatestFrom(contribution)
            .map{ pair -> Contribution in
                let contribution = Contribution(contributor: pair.contributor ,body: pair.body)
                return contribution
            }
            .debug("contribution")
            .flatMap { (contribution) -> PrimitiveSequence<SingleTrait, Response> in
                return provider.rx.request(.create(contribution)).retry(3)
            }.debug("response")
    }
}
