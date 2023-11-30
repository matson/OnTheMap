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
                // Assuming studentData is an array of StudentLocation objects

                // Clear the existing studentLocations array
                DataManager.shared.studentLocations.removeAll()

                // Iterate over each StudentLocation object and append to the studentLocations array
//                for studentLocation in studentData {
//                    let locationDict: [String: Any] = [
//                        "firstName": studentLocation.firstName,
//                        "lastName": studentLocation.lastName,
//                        "latitude": studentLocation.latitude,
//                        "longitude": studentLocation.longitude,
//                        "link": studentLocation.mediaURL,
//                        "location": studentLocation.mapString
//                    ]
//                    DataManager.shared.studentLocations.append(locationDict)
//                }
//
//                print(DataManager.shared.studentLocations)
                DataManager.shared.studentLocations.append(contentsOf: studentData)
                print(self.student)
                self.tableView.reloadData()

            } else {
                // Handle error
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //tableView.reloadData()
        
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
        //let firstName = students["firstName"] as? String
        //let lastName = students["lastName"] as? String
        //cell.textLabel?.text = firstName ?? "" + (lastName ?? "")
        
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
