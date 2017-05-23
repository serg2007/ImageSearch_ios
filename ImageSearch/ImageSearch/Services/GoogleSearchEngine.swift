//
//  GoogleSearchEngine.swift
//  ImageSearch
//
//  Created by Sergiy Sobol on 22.05.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import Foundation

class GoogleSearchEngine {
    func search(s: String, callback: @escaping (Error?, [[String: Any]]?)->Void) {
        let url = URL(string: "https://www.googleapis.com/customsearch/v1?key=AIzaSyAJ4obtfPRvxpil3OI_tw42tHbsR7VWXkU&cx=003520820539694573172:m11gxiqkoqe&q=\(s)&searchType=image")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
           
            if let dict = json as? [String: Any] {
                if let array = dict["items"] as? [[String: Any]] {
                    callback(nil, array)
                }
            }
        }.resume()
        
    }
}
