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
    var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with isEditing: Observable<Bool>, action: CocoaAction) {
        isEditing.bind(to: body.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        
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
        
        isEditing.bind(to: editButton.rx.isHidden).disposed(by: disposeBag)
        isEditing.map{ !$0 }.bind(to: doneButton.rx.isHidden).disposed(by: disposeBag)
        isEditing.map{ !$0 }.bind(to: cancelButton.rx.isHidden).disposed(by: disposeBag)
        
        editButton.rx.action = action
    }
    
    override func prepareForReuse() {
        editButton.rx.action = nil
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
}


