//
//  CustomRemoteDataSource.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

class CustomRemoteDataSource: AZRemoteTableDataSource {

    //An array in which we will store the data.
    fileprivate var items: [String] = []


    /// Helper function to add items.
    public func addItems(items: [String]){
        for item in items { self.items.append(item) }
    }

    /// Helper function to clear items.
    public func clearItems() {
        items.removeAll()
        reset()
    }

    // MARK: - AZRemoteTableDataSource

    override func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        //simple implementation of cellForRowAt:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    override func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        //return the number of items currently held.
        return items.count
    }
}
