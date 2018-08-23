//
//  AZRemoteTableDataSource.swift
//  AZAutoTableView
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit.UITableView
import UIKit.UITableViewCell

open class AZRemoteTableDataSource: NSObject, UITableViewDataSource {


    /// A flag used to indicate if we want to show the loading cell, true when hasMore is true.
    fileprivate(set) open var showLoadingIndicator: Bool = false


    /// Indicates if we should display an error or not.
    fileprivate(set) open var isErrorMode: Bool = false


    /// A flag that indicates if there is data or not.
    fileprivate(set) open var hasData: Bool = false


    /// The number of items in the data source array.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number
    /// - Returns: The number of data items to display.
    open func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        fatalError("Unimplemented Function")
    }

    open func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        fatalError("Unimplemented Function")
    }

    open func reset(){
        hasData = false
        isErrorMode = false
    }


    /// A delegate function used to return the loading cell.
    ///
    /// - Parameter tableView: The table view.
    /// - Returns: A UITableViewCell used to indicated the "Load More"
    open func loadingCellFor(_ tableView: UITableView,usingView view: UIView) -> UITableViewCell {
        return LoadingCell(view: view, style: .default, reuseIdentifier: "loading_cell")
    }


    /// A function called whenever a row is needed to be displayed.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The index path.
    /// - Returns: The table view cell to display.
    public final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(tableView, indexPath) {
            
            let view: UIView

            if isErrorMode {
                view = errorView(tableView, forLoadingCell: true) ?? UIView()
                isErrorMode = false
            }else {
                view = loadingView(tableView, forLoadingCell: true) ?? UIView()
            }

            return loadingCellFor(tableView,usingView: view)
        }else {
            return cellForRowAt(tableView,indexPath: indexPath)
        }
    }


    /// Providing implementation for the numberOfRowsInSection: function.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: The number of items in that section.
    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = self.numberOfRowsInSection(tableView,section: section)
        return numberOfItems + ( shouldLoadMore(tableView) ? 1 : 0 )
    }


    /// Returns the view to display as the refresh control.
    ///
    /// - Parameter tableView: The tableview using this control.
    /// - Returns: UIRefreshControl to display. return nil to display no refresh control.
    open func refreshControl(_ tableView: UITableView) -> UIRefreshControl? {
        return UIRefreshControl()
    }


    /// Returns the view to display when loading initial data.
    ///
    /// - Parameter tableView: The tableview.
    /// - Returns: The view to display as the loading indicator.
    open func loadingView(_ tableView: UITableView,forLoadingCell: Bool) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        return activityIndicator
    }


    /// Returns the view to display when an error occur.
    ///
    /// - Parameters:
    ///   - tableView: The tableview.
    ///   - forLoadingCell: A boolean flag used to indicated if this view will be used in a cell or the entire table.
    /// - Returns: A view to show the error, nil to show none.
    open func errorView(_ tableView: UITableView,forLoadingCell: Bool) -> UIView? {
        let errorLabel = ErrorButton(type: .system)
        errorLabel.onClick = { btn in
            let remote = tableView.remote
            let currentPage = remote.delegate?.currentPage ?? -1
            if currentPage == 0 {
                remote.initialLoad()
            }else {
                tableView.reloadData()
            }
        }
        errorLabel.setTitle("Try Again", for: [])
        errorLabel.setTitleColor(UIColor.red, for: [])
        return errorLabel
    }

    
    /// Use this method do enable the loading indicator visabilty.
    ///
    /// - Parameter tableView: The table view.
    /// - Returns: Return true to load more, else return false.
    open func shouldLoadMore(_ tableView: UITableView) -> Bool {
        return showLoadingIndicator
    }

    /// A function called by the wrapper. never call this directly.
    ///
    /// - Parameter hasMore: a flag which indicates if there is more data to load.
    public final func notify(hasMore: Bool){
        showLoadingIndicator = hasMore
        hasData = true
        isErrorMode = false
    }

    public final func notifyError(){
        isErrorMode = true
    }


    /// A function that checks if the current indexpath is a loading cell.
    ///
    /// - Parameters:
    ///   - tableView: The current table view.
    ///   - indexPath: The index path to check.
    /// - Returns: True if the index path belongs to a loading cell.
    internal func isLoadingIndexPath(_ tableView: UITableView,_ indexPath: IndexPath) -> Bool {
        guard shouldLoadMore(tableView) else { return false }
        return indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1
    }
}


/// Custom UIButton sub class used for the default error view.
fileprivate class ErrorButton: UIButton {
    open var onClick: ((UIButton)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func click(){
        onClick?(self)
    }
}

/// The default loading cell
fileprivate class LoadingCell: UITableViewCell {

    convenience init(view: UIView, style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
