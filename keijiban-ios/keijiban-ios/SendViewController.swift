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

    let provider = MoyaProvider<ContributionAPI>(stubClosure: { (_: ContributionAPI) -> Moya.StubBehavior in
        return .immediate
    })
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var body: UITextView!

    @IBAction func buttonTapped(_ sender: Any) {
        guard let name = name.text, let body = body.text else {
            return
        }
        let contribution = Contribution(contributer: name, body: body)
        provider.rx.request(.create(contribution))
            .subscribe(onSuccess: { (response) in
                print(response.data)
            }) { (error) in
                print(error)
        }
                
    }

    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

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
