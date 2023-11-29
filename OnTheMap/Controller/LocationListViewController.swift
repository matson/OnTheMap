//
//  LocationListController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation
import UIKit

class LocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var students: [StudentInformation] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
            super.viewWillAppear(animated)
            tableView.reloadData()
            
    }
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return the students already pinned
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell", for:indexPath)
        
        let student = self.students[(indexPath as NSIndexPath).row]
        
        //setting student name to label property of table cell
        //cell.label?.text = student.fullname
        
        return cell
    }
    
    //MARK: BarButton Items
    
    @IBAction func postPin(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "postPin", sender: nil)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
