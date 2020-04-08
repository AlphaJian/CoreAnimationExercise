//
//  ViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/3.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    let datasource = ["摇铃", "点答"]

    lazy var tableview: UITableView = {
        let tb = UITableView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100), style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addSubview(tableview)
        tableview.reloadData()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = datasource[indexPath.row]
        switch text {
        case "摇铃":
            self.navigationController?.pushViewController(ShakingRingViewController(), animated: true)
        case "点答":
            self.navigationController?.pushViewController(AnsweringViewController(), animated: true)
        default:
            break
        }
    }
}

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}
