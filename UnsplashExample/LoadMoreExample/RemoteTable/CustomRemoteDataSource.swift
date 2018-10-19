//
//  CustomRemoteDataSource.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit
import AZRemoteTable
import Kingfisher
import AZImagePreview

class CustomRemoteDataSource: AZRemoteTableDataSource {

    weak var imageDelegate: AZPreviewImageViewDelegate?

    //An array in which we will store the data.
    fileprivate var items: [ImageObject] = []


    /// Helper function to add items.
    public func addItems(items: [ImageObject]){
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ImageCell
        cell.img.kf.setImage(with: URL(string: items[indexPath.row].link))
        cell.img.delegate = imageDelegate
        return cell
    }

    override func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        //return the number of items currently held.
        return items.count
    }

    override func errorView(_ tableView: UITableView, forLoadingCell: Bool) -> UIView? {
        if forLoadingCell { return super.errorView(tableView, forLoadingCell: forLoadingCell) }

        let emptyStateView = MyEmptyStateView(image: #imageLiteral(resourceName: "dead"), message: "Something went wrong!", buttonText: "Try Again")
        emptyStateView.messageTextColor = .black
        (emptyStateView.button as! HighlightableButton).onClick = { btn in tableView.remote.load() }

        return emptyStateView
    }
}
