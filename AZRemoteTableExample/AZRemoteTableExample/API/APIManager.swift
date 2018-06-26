//
//  APIManager.swift
//  AZRemoteTableExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation

/// Fake api manager
class APIManager {

    static let shared: APIManager = APIManager()

    func loadData(id: String, token: String,page: Int,itemsPerPage: Int, callback: ( (String, [String], String)->() )?){

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            var arr = [String]()

            let start = page * itemsPerPage
            let end = page * itemsPerPage + itemsPerPage
            for i in start ..< end   {
                arr.append("VALUE \(i+1)")
            }
            callback!("value1",arr,"value2")
        }
    }
}
