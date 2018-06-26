//
//  ViewController.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let delegate = CustomRemoteDelegate()
    let dataSource = CustomRemoteDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.remote.initialLoad()
    }
}

