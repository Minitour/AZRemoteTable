//
//  AZRemoteTable.swift
//  AZAutoTableView
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UITableView {
    public var remote: AZRemoteTable { return AZRemoteTable(self) }
}

/// Table View Wrapper
public class AZRemoteTable: NSObject {

    /// unowned reference to the table view.
    fileprivate(set) open unowned var tableView: UITableView

    public init(_ table: UITableView) {
        tableView = table
        super.init()
    }

    public var delegate: AZRemoteTableDelegate? {
        return tableView.delegate as? AZRemoteTableDelegate
    }

    public var dataSource: AZRemoteTableDataSource? {
        return tableView.dataSource as? AZRemoteTableDataSource
    }

    /// Call when notifying that the table is ready for updates.
    public func notifySuccess(hasMore: Bool) {
        DispatchQueue.main.async() {
            //notify delegate/datasource
            self.delegate?.notify(success: true)
            self.dataSource?.notify(hasMore: hasMore)

            //update views
            if let refreshControl = self.tableView.refreshControl {
                refreshControl.endRefreshing()
            }


            //reload data
            self.tableView.reloadData()
        }
    }

    public func notifyError() {
        //notify delegate
        DispatchQueue.main.async {
            self.delegate?.notify(success: false)
            self.dataSource?.notifyError()

            //update views
            if let refreshControl = self.tableView.refreshControl {
                refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }

    public func initialLoad() {
        if let delegate = delegate, !delegate.didInitialLoad {
            delegate.tableView = tableView

            //setup loading pull indicator
            if let refreshControl = dataSource?.refreshControl(tableView) {
                delegate.tableView(tableView, setupRefreshControl: refreshControl)
                tableView.refreshControl = refreshControl
            }

            tableView.tableFooterView = UIView()

            delegate.tableView(tableView, didRequestPage: 0)
        } else {
            print("initial Load: Can only be called once.")
        }
    }
}
