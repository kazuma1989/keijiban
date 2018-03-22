//
//  SendViewController.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/14.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class SendViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    let disposeBag: DisposeBag = DisposeBag()
    let model: ContributionModel = ContributionModel.instance
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = SendViewModel(input: (body: body.rx.text.orEmpty.asDriver(), sendTapped: sendButton.rx.tap.map{_ in }))
        
        body.layer.borderWidth = 1.0
        body.layer.borderColor = UIColor.black.cgColor

        viewModel.send.subscribe(onNext:{ [weak self] _ in
            self?.model.update()
            self?.dismiss(animated: true, completion: nil)
        },onError:{[weak self] error in
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "通信エラーが発生しました。再送信してください。", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
            }
            alert.addAction(defaultAction)
            self?.present(alert, animated: true, completion:nil)
        }).disposed(by: disposeBag)
        
        cancel.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
