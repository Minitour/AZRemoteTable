//
//  APIManager.swift
//  LoadMoreExample
//
//  Created by Antonio Zaitoun on 26/06/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate typealias RESPONSE_INTERNAL = (JSON?,Error?)->Void

struct Constants {
    static let client_id = ""
    static let client_secret = ""
    static let redirect_uri = ""
    static let code = ""
    static let grant_type = ""
}

public class APIManager {

    public static let shared = APIManager()


    fileprivate var mainManager = SessionManager.default

    open func getPhotos(page: Int,callback: @escaping ([ImageObject],Error?)->Void) {

        let url = "https://api.unsplash.com/photos?page=\(page)&client_id=\(Constants.client_id)"

        makeAPICall(method: .get,toRoute: url, parameters: ["client_id":Constants.client_id]) { (json, error) in

            guard error == nil else { callback([],error); return }

            var images = [ImageObject]()
            if let jsonArray = json?.array {
                for element in jsonArray {
                    images.append(ImageObject(id: element["id"].string!,
                                              description: element["description"].string ?? "",
                                              link: element["urls"]["regular"].string!))
                }
                callback(images,nil)
            }
        }
    }

    fileprivate func makeAPICall(method: HTTPMethod = .post,
                                 toRoute route: String,
                                 parameters params: Parameters,
                                 headers: HTTPHeaders? = nil,
        closure: @escaping RESPONSE_INTERNAL){
        mainManager.request(route, method: method, parameters: params, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                closure(json,nil)
                break
            case .failure(let error):
                closure(nil, error)
                break
            }
        }
    }
}
