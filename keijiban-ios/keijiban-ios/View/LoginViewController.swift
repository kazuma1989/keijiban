//
//  LoginViewController.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/21.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class LoginViewController: UIViewController {

    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let provider = MoyaProvider<ContributionAPI>(stubClosure: {
            (_: ContributionAPI) -> Moya.StubBehavior in
            return .never
        })
        
        // Do any additional setup after loading the view.
        let loginObservable = Observable.combineLatest(id.rx.text, password.rx.text) { id, password -> LoginRequest in
            return LoginRequest(id: id!, password: password!)
        }
        
        loginButton.rx.tap.withLatestFrom(loginObservable)
            .do(onNext: {
                UserDefaults.standard.set($0.id, forKey: "userId")
            })
            .debug("tap")
            .flatMap { data -> Single<Response> in
           return provider.rx.request(.login(data))
            }
            .map(LoginResponse.self)
            .debug("login")
            .subscribe ( onNext: { [weak self] response in
                UserDefaults.standard.set(response.token, forKey:"SessionKey")
                self?.performSegue(withIdentifier: "login", sender: nil)
            },
                         onError: { _ in
                            let alert = UIAlertController(title: "ログイン失敗", message: "ログインに失敗しました", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated:true, completion: nil)
                UserDefaults.standard.removeObject(forKey: "userId")
            }
        ).disposed(by: disposeBag)
        

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
