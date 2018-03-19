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
import Action

class ViewModel {
    
    let contribution: Observable<[Contribution]>
    let editingContributionId: BehaviorSubject<Int>
    let model: ContributionModel = ContributionModel.instance

    init() {
        contribution = model.contribution.asObservable().debug("fromModel")
        model.fetchContribution()
        editingContributionId = BehaviorSubject<Int>(value: 0) // 0は全てのIDが更新対象ではないことを指す。現在IDは16桁なのでいけている。
        
    }
    
    func onEdit(with: Contribution) -> CocoaAction {
        return CocoaAction { _ in
            self.editingContributionId.onNext(with.id)
            return Observable.empty()
        }
    }
    
    func onCancel() -> CocoaAction {
        return CocoaAction { _ in
           self.editingContributionId.onNext(0)
            return Observable.empty()
        }
    }
    
    func onDone(with: Contribution) -> CocoaAction {
        return CocoaAction { _ in
           return Observable.empty()
        }
    }
}
