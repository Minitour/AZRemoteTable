//
//  CustomRemoteDelegate.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit.UITableView

class CustomRemoteDelegate: AZRemoteTableDelegate {
    override func tableView(_ tableView: UITableView, didRequestPage page: Int,usingRefreshControl: Bool) {

        // Make an API call.
        APIManager.shared.loadData(id: "a9dd9e00-55f8-4ce8-8ada-8e933d052e3a",
                                   token: "b54695d5-6f98-442f-9b39-4509fcd8aacd",
                                   page: page,
                                   itemsPerPage: 30) { (value1, value2, value3) in

                                    let error = page == 2

                                    //check for errors
                                    if error {
                                        //error found, notify table
                                        tableView.remote.notifyError()
                                    }else {
                                        //all good, data fetched, add it to the data source.
                                        let dataSource = tableView.remote.dataSource as? CustomRemoteDataSource

                                        //clear all items if we used pull to refresh
                                        if usingRefreshControl { dataSource?.clearItems() }

                                        //update data source
                                        dataSource?.addItems(items: value2)

                                        //notify table that we are done, and if we have more data to load.
                                        tableView.remote.notifySuccess(hasMore: true)
                                    }
        }
    }
}
