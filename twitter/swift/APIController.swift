//
//  APIController.swift
//  twitter
//
//  Created by Danyil ZBOROVKYI on 6/29/19.
//  Copyright © 2019 Danyil ZBOROVKYI. All rights reserved.
//

import Foundation

protocol APITwitterDelegate {
    func processTweet(array: [Tweet])
    func error(_ error: NSError)
}

class APIController {
    var delegate: APITwitterDelegate?
    let token: String
    
    init(delegete: APITwitterDelegate?, token: String) {
        self.delegate = delegete
        self.token = token
    }
    
    func requestTwitter(search: String) {
        var tweets: [Tweet] = []
        
        let urlQ = search.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlCount = "100"
        let urlResultType = "recent"
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(urlQ)&result_type=\(urlResultType)&count=\(urlCount)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " +  self.token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        //print(response!)
            if let error = error {
                if let delegate: APITwitterDelegate = self.delegate {
                    delegate.error(error as NSError)
                }
            } else if let d = data {
                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: d, options: []) as? [String:AnyObject],
                        let arrayStatuses = responseObject["statuses"] as? [[String:AnyObject]] {
                        //print(arrayStatuses)
                        //print("Data items count: \(arrayStatuses.count)")
                        for status in arrayStatuses {
                            let text = status["text"] as! String
                            //print(text)
                            let user = status["user"]?["name"] as! String
                            //print(user)
                            if let date = status["created_at"] as? String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                if let date = dateFormatter.date(from: date) {
                                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                    let newDate = dateFormatter.string(from: date)
                                    tweets.append(Tweet(name: user, text: text, date: newDate))
                                }
                            }
                        }
                    }
                    
                    if let delegate: APITwitterDelegate = self.delegate {
                        delegate.processTweet(array: tweets)
                    }
                } catch _{
                    print("error")
                }
            }
        }
        task.resume()
    }
}











