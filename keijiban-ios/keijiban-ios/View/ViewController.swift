//
//  ViewController.swift
//  keijiban-ios
//
//  Created by 原野誉大 on 2018/03/13.
//  Copyright © 2018年 原野誉大. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ViewController: UIViewController {

    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: String(describing: ContributionTableViewCell.self), bundle: nil), forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self

        viewModel.contribution.bind(to: tableView.rx.items) { [weak self] tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContributionTableViewCell
            cell.contributor.text = element.contributor
            cell.body.text = element.body
            cell.id.text = String(element.id)
            if let strongSelf = self {
                cell.configure(with: strongSelf.viewModel.editingContributionId.map{$0 == element.id},
                               editing: strongSelf.viewModel.onEdit(with: element),
                               cancel: strongSelf.viewModel.onCancel(),
                               done: strongSelf.viewModel.onDone(with: element))
                
            }

            return cell
        }.disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212.5
    }
    
}
