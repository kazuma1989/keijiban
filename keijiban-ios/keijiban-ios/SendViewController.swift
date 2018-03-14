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

    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewModel(input: (contributer: name.rx.text.orEmpty.asDriver(),  body: body.rx.text.orEmpty.asDriver(), sendTapped: sendButton.rx.tap.map{_ in }))

        viewModel.send.subscribe(onNext:{ _ in
           print("Success")
        },onError:{ error in
            print(error)
        })
            

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
