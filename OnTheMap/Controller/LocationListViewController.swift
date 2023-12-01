//
//  LocationListController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation
import UIKit

class LocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var student = DataManager.shared.studentLocations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //call the getStudentLocation method here to populate table.
        UdacityClient.getStudentLocation { studentData, error in
            if let studentData = studentData {
                self.student.append(contentsOf: studentData)
                DispatchQueue.main.async {
                           self.tableView.reloadData()
                }
            }
            else{
                print("nah")
            }
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return the students already pinned
        return student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell", for:indexPath)
        
        let students = self.student[(indexPath as NSIndexPath).row]
        
        //setting student name to label property of table cell
        let firstName = students.firstName
        let lastName = students.lastName
        cell.textLabel?.text = firstName + " " + lastName
        
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
