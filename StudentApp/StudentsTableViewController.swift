//
//  StudentsTableViewController.swift
//  StudentApp
//
//  Created by Kely Sotsky on 06/04/2022.
//

import UIKit
import Kingfisher


class StudentsTableViewController: UITableViewController {
    
    var data = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:
                                              #selector(reload),
                                              for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString("Loading List...")
        
        Model.studentDataNotification.observe {
            self.reload()
        }
        reload()
        
    }
    
    
    @objc func reload(){
        if self.refreshControl?.isRefreshing == false {
            self.refreshControl?.beginRefreshing()
        }
        Model.instance.getAllStudents(){
            students in
            self.data = students
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentTableViewCell
        let st = data[indexPath.row]
        cell.nameLabel.text = st.name!
        cell.id = st.id!
        if let urlStr = st.avatarUrl {
            let url = URL(string: urlStr)
            cell.avatar?.kf.setImage(with: url)
        }else{
            cell.avatar.image = UIImage(named: "avatar")
        }
        return cell
    }
    
    var selectedRow = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Selcted row at \(indexPath.row)")
        selectedRow = indexPath.row
        performSegue(withIdentifier: "openStudentDetails", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openStudentDetails"){
            let dvc = segue.destination as! StudentDetailsViewController
            let st = data[selectedRow]
            dvc.student = st
        }
    }
    
    
}
