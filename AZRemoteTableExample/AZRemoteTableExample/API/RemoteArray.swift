//
//  RemoteArray.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 12/10/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation

public protocol RemoteArrayDelegate: class {

    func didFinishLoadingMore(hasMore: Bool)

}

open class RemoteArray<T: Any> {

    open weak var delegate: RemoteArrayDelegate?
    
    var data: [T] = []

    final public subscript(index: Int) -> T {
        get {
            //check if accessed last element
            if index == data.count - 1 {
                //preform fetch
                loadMore(index)
            }
            return data[index]
        }
        set(newValue) {
            data[index] = newValue
        }
    }

    open func loadMore(_ index: Int) {

    }


}
