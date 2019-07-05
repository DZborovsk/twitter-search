//
//  ViewController.swift
//  twitter
//
//  Created by Danyil ZBOROVKYI on 6/29/19.
//  Copyright © 2019 Danyil ZBOROVKYI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    var token: String?
    var apiController: APIController?
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableView.automaticDimension
        initToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func processTweet(array: [Tweet]) {
        self.tweets = array
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func error(_ error: NSError) {
        
        let alertController = UIAlertController(title: "Error", message: "Error: \(error)", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! TableViewCell
        
        let item = tweets[indexPath.row]
        cell.cellCinfigurate(tweet: item)
        tableView.rowHeight = UITableView.automaticDimension
        return cell
    }


    func initToken() {
        let CUSTOMER_KEY = "lLcKyFu8N6gtXDiBJW7PJsh33"
        let CUSTOMER_SECRET = "jnb8joITxTUCfELOSX8yAkGCWBaqSG1J439RHPlhENw2CFeDAa"
        let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print(response!)
            
            if let error = error {
                print(error)
            } else if let data = data {
                do  {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        //print(dic)
                        self.token = (dic["access_token"] as! String)
                        //print(self.token!)
                        self.apiController = APIController(delegete: self, token: self.token!)
                        self.apiController?.requestTwitter(search: "school 42")
                    }
                }
                catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        apiController?.requestTwitter(search: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
}

