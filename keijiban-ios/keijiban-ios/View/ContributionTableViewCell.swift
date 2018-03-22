//
//  ContributionTableViewCell.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/16.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import UIKit
import RxSwift
import Action
import RxCocoa

class ContributionTableViewCell: UITableViewCell {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var contributor: UILabel!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    var original: String?
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with isEditing: Observable<Bool>, editing: CocoaAction, cancel: CocoaAction, done: Action<(String, String), Void>, delete: CocoaAction) {
        guard let id = UserDefaults.standard.string(forKey: "userId") else {
            return
        }
        isEditing.bind(to: body.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        
        let isMineObservable = Observable<Bool>
                .combineLatest(
            Observable<String>.of(id).debug("id"),
            Observable<String>.of(self.contributor.text!).debug("text")
                ) {
                    !($0 == $1)
            }.debug("is")

        
        isEditing
            .map{ bool -> CGFloat in
                if bool {
                    return 1.0
                }else {
                    return 0.0
                }
            }.subscribe(onNext: { width in
                self.body.layer.borderWidth = width
            }).disposed(by: disposeBag)
        
        let editButtonEnableObservable = Observable.combineLatest(
            isMineObservable,
            isEditing
        ) {
            $0 || $1
            }.debug("hidden")
        

        editButtonEnableObservable.bind(to: editButton.rx.isHidden).disposed(by: disposeBag)
        editButtonEnableObservable.bind(to: deleteButton.rx.isHidden).disposed(by: disposeBag)
        isEditing.map{ !$0 }.bind(to: doneButton.rx.isHidden).disposed(by: disposeBag)
        isEditing.map{ !$0 }.bind(to: cancelButton.rx.isHidden).disposed(by: disposeBag)
        
        editButton.rx.action = editing
        deleteButton.rx.action = delete
        cancelButton.rx.tap.subscribe(onNext: { [weak self ]_ in
            if let original = self?.original {
                self?.body.text = original
                
            }
           cancel.execute(())
        }).disposed(by: disposeBag)
        doneButton.rx.tap.subscribe(onNext: { _ in
            done.execute((self.id.text!, self.body.text!))
        }).disposed(by: disposeBag)

    }
    
    override func prepareForReuse() {
        editButton.rx.action = nil
        cancelButton.rx.action = nil
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
}


