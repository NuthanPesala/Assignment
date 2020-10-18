//
//  ViewController.swift
//  Assignment
//
//  Created by Nuthan Raju Pesala on 17/10/20.
//  Copyright © 2020 NuthanRaju. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
 
    // IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    var list = [APOD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "APOD"
        self.navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.fetchAllAPOD()
    }

 // API Calling: Fetching all the list of metadata of NASA’s Astronomy Picture of  the Day (APOD).
   
    func fetchAllAPOD() {
        guard let url = URL(string: "http://demo0405353.mockable.io/get-nasa-photos") else {
            print("Invalid Url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to get Data", error?.localizedDescription as Any)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    guard let data = data else {
                        print("Data Not found")
                        return
                    }
                    do {
                        if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            if let photosData = jsonData["photos"] as? [[String: Any]] {
                                var object = APOD(title: "", description: "", date: "", media_type: "", url: "")
                               // var list = [APOD]()
                                for data in photosData {
                                    if let date = data["date"] as? String {
                                        object.date = date
                                    }
                                    if let title = data["title"] as? String {
                                        object.title = title
                                    }
                                    if let explanation = data["explanation"] as? String {
                                        object.description = explanation
                                    }
                                    if let mediaType = data["media_type"] as? String {
                                        object.media_type = mediaType
                                    }
                                    if let url = data["url"] as? String {
                                        object.url = url
                                    }
                                    self.list.append(object)
                                }
                                DispatchQueue.main.async {
                                 self.tableView.reloadData()
                                }
                            }
                        }
                        
                    }
                    catch {
                        print("Error")
                    }
                }
            }
        }.resume()
        
    }
    
}

//MARK:- UITABLEVIEW DATA SOURCE METHODS-
extension ViewController: UITableViewDataSource {
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    // Populating Content in every row in TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APODTableViewCell", for: indexPath) as! APODTableViewCell
        let object = list[indexPath.row]
        cell.object = object
        return cell
    }
    
    
}
//MARK:- UITABLEVIEW DELEGATE METHODS-
extension ViewController: UITableViewDelegate {
    // On click of every row in TableView it navigates to the Detail View Controller.Where you can see the clear details of that object
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailTableViewController") as! DetailTableViewController
         let object = list[indexPath.row]
        detailVC.object = object
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
