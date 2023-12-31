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
        UdacityClient.getStudentLocation { studentData, error, success in
            if success {
                if let studentData = studentData {
                    self.student.append(contentsOf: studentData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            else{
                // Handle failure and notify the user
                let alert = UIAlertController(title: "Error", message: "Failed to download student locations.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell", for: indexPath) as! PinTableViewCell
        
        let students = self.student[(indexPath as NSIndexPath).row]
        
        //setting student name to label property of table cell
        let firstName = students.firstName
        let lastName = students.lastName
        cell.label.text = firstName + " " + lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle the tap on the cell
        let selectedData = student[indexPath.row]
        let urlString = selectedData.mediaURL
        
        if !urlString.isEmpty {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    print("Invalid URL")
                }
            } else {
                print("Invalid URL string")
            }
        } else {
            print("Invalid mediaURL")
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
