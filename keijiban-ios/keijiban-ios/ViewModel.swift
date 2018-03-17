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
    let model: ContributionModel = ContributionModel.instance

    init() {
        contribution = model.contribution.asObservable().debug("fromModel")
        model.fetchContribution()
        
    }
}
