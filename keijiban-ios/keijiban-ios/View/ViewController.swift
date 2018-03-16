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
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: String(describing: ContributionTableViewCell.self), bundle: nil), forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self

        viewModel.contribution.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContributionTableViewCell
            cell.contributor.text = element.contributor
            cell.body.text = element.body
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
