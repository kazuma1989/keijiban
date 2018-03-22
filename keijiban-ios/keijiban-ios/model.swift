//
//  model.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/17.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxCocoa

class ContributionModel {
    
    static let instance = ContributionModel()
    let disposeBag = DisposeBag()
    let contribution: PublishSubject<[Contribution]> = PublishSubject<[Contribution]>()
    
    let provider = MoyaProvider<ContributionAPI>(stubClosure: {
        (_: ContributionAPI) -> Moya.StubBehavior in
        return .never
    },plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func update() {
        fetchContribution()
    }
    
    func fetchContribution() {
        provider.rx.request(.list).map([Contribution].self).debug("fetchContribution").subscribe(onSuccess: { (contributions) in
            self.contribution.onNext(contributions)
        }) { (error) in
            self.contribution.onError(error)
        }.disposed(by: disposeBag)
            
    }
}
