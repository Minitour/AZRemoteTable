//
//  AZRemoteTableDelegate.swift
//  AZAutoTableView
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public class AZRemoteTableDelegate: NSObject, UITableViewDelegate {

    open weak var tableView: UITableView?

    /// The current page that we are fetching.
    fileprivate(set) open var currentPage: Int = 0 {
        didSet{ if !didInitialLoad { didInitialLoad = true} }
    }

    /// A flag indicating if the delegate is in a middle of a fetch.
    fileprivate(set) open var awaitingEvent: Bool = false

    /// A flag that indicates if there is more data to load.
    fileprivate(set) open var loadMore: Bool = true

    /// A flag that indicates if we loaded the first time.
    fileprivate(set) open var didInitialLoad: Bool = false

    public final func tableView(_ tableView: UITableView, setupRefreshControl refreshControl: UIRefreshControl){
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }

    /// Gets called when tableview gets refreshed by the user.
    ///
    /// - Parameters:
    ///   - tableView: The table view
    ///   - control: The refresh control
    public func tableView(_ tableView: UITableView, didRefreshWithControl control: UIRefreshControl){}


    /// Function to override, gets called when the table needs to load more data.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - didRequestPage: The page being requested.
    public func tableView(_ tableView: UITableView, didRequestPage page: Int,usingRefreshControl: Bool = false){}

    //TODO: - Detect pull to refresh event and notify data source.


    /// Called before displaying a certain cell on the table. Overrided in order to detect when reaching the bottom.
    ///
    /// - Parameters:
    ///   - tableView:
    ///   - cell:
    ///   - indexPath:
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        //get last element index
        let lastElement = tableView.remote.dataSource?.numberOfRowsInSection(tableView, section: indexPath.section) ?? 1

        // if last element is the current index
        if loadMore, indexPath.row == lastElement {

            //if not awaiting event
            if !awaitingEvent {
                awaitingEvent = true
                self.tableView(tableView, didRequestPage: currentPage)
            }
        }
    }


    /// Notify delegate that the event has passed. Never call this function directly.
    /// This will get called only from the remote wrapper.
    public final func notify(success: Bool){

        awaitingEvent = false

        if success {
            currentPage += 1
        }
    }

    @objc fileprivate func didPullToRefresh(_ target: UIRefreshControl) {
        if let tableView = tableView {

            //notify delegate method
            self.tableView(tableView, didRefreshWithControl: target)

            //reset current page
            currentPage = 0

            //call did request page 0
            self.tableView(tableView, didRequestPage: 0,usingRefreshControl: true)
        }
    }
}
