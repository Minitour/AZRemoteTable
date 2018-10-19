//
//  CustomRemoteDelegate.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit.UITableView
import AZRemoteTable
import AZEmptyState

class CustomRemoteDelegate: AZRemoteTableDelegate {

    override func tableView(_ tableView: UITableView, layoutView view: UIView) {
        super.tableView(tableView, layoutView: view)
        view.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.7).isActive = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let dataSourceCount = tableView.remote.dataSource?.numberOfRowsInSection(tableView, section: indexPath.section) ?? 0
        if indexPath.row == dataSourceCount {
            return 44
        }

        return 224

    }

    override func tableView(_ tableView: UITableView, didRequestPage page: Int,usingRefreshControl: Bool) {

        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 3.0) {
            // Make an API call.
            APIManager.shared.getPhotos(page: page + 1) { (images, error) in
                if error != nil {
                    tableView.remote.notifyError()
                }else {
                    let dataSource = tableView.remote.dataSource as? CustomRemoteDataSource

                    if usingRefreshControl { dataSource?.clearItems() }

                    dataSource?.addItems(items: images)

                    tableView.remote.notifySuccess(hasMore: true)
                }
            }
        }


    }
}
