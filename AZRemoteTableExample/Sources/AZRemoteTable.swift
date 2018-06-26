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

    fileprivate let INNER_VIEW_ID: Int = 1711

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
            let currentPage = self.delegate?.currentPage ?? -1

            if currentPage == 0 {
                //first load - remove loading indicator if exists.
                self.removeViewIfExist()
            }

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


    /// Function used to notify the delegate, the data source and the table view that new data could not be loaded.
    public func notifyError() {
        //notify delegate
        DispatchQueue.main.async {
            self.delegate?.notify(success: false)
            self.dataSource?.notifyError()

            //update views
            if let refreshControl = self.tableView.refreshControl {
                refreshControl.endRefreshing()
            }

            let hasData = self.dataSource?.hasData ?? false
            let currentPage = self.delegate?.currentPage ?? -1

            //if currnet page is 0, and table has no data
            if currentPage == 0 {

                self.removeViewIfExist()

                if !hasData {
                    //get the error view, if exists
                    if let loadingView = self.dataSource?.errorView(self.tableView, forLoadingCell: false) {
                        //set the tag on the view
                        loadingView.tag = self.INNER_VIEW_ID

                        //send to layoutView delegate function
                        self.delegate?.tableView(self.tableView, layoutView: loadingView)
                    }
                }
            }

            self.tableView.reloadData()
        }
    }


    /// Function used to do the initial setup and make the initial load.
    public func initialLoad() {
        if let delegate = delegate, !delegate.didInitialLoad {
            delegate.tableView = tableView

            //setup loading pull indicator
            if let refreshControl = dataSource?.refreshControl(tableView) {
                delegate.tableView(tableView, setupRefreshControl: refreshControl)
                tableView.refreshControl = refreshControl
            }

            tableView.tableFooterView = UIView()

            let hasData = self.dataSource?.hasData ?? false
            let currentPage = self.delegate?.currentPage ?? -1

            //if currnet page is 0, and table has no data
            if currentPage == 0 {

                self.removeViewIfExist()

                if !hasData {
                    //get the loading view, if exists
                    if let loadingView = self.dataSource?.loadingView(self.tableView, forLoadingCell: false) {
                        //set the tag on the view
                        loadingView.tag = self.INNER_VIEW_ID

                        //send to layoutView delegate function
                        self.delegate?.tableView(self.tableView, layoutView: loadingView)
                    }
                }
            }

            //make request for page 0
            delegate.tableView(tableView, didRequestPage: 0)
        } else {
            print("initial Load: Can only be called once.")
        }
    }

    fileprivate func removeViewIfExist(){
        for view in self.tableView.subviews {
            if view.tag == INNER_VIEW_ID {
                view.removeFromSuperview()
            }
        }
    }
}
