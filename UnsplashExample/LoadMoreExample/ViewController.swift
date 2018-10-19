//
//  ViewController.swift
//  LoadMoreExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit
import AZRemoteTable
import AZImagePreview

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let delegate = CustomRemoteDelegate()
    let dataSource = CustomRemoteDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        dataSource.imageDelegate = self
        tableView.remote.load()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: AZPreviewImageViewDelegate{
    func previewImageViewInRespectTo(_ previewImageView: UIImageView) -> UIView? {
        //return self.view or self.navigationController?.view (if you are using a navigation controller.
        return view
    }

    func previewImageView(_ previewImageView: UIImageView, requestImagePreviewWithPreseneter presenter: AZImagePresenterViewController) {
        present(presenter, animated: false, completion: nil)
    }
}

class ImageCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
}

