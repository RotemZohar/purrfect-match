//
//  StarWarsViewController.swift
//  PurrfectMatch
//
//  Created by admin on 08/06/2022.
//

import UIKit

class DogBreedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var data:[DogBreed] = [DogBreed]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString("Loading...")
        self.tableView.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        reload()
        
    }
    
    @objc func reload(){
        self.tableView.refreshControl?.beginRefreshing()
        DogApi.getThreeBreeds { breeds in
            self.data = breeds
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SWCell", for: indexPath) as! DogBreedTableViewCell
        
        let breed = data[indexPath.row]
        cell.breedName.text = breed.name
        cell.lifeSpan.text = "Life Span: " + (breed.lifeSpan ?? "Unknown")
        cell.origin.text = "Origin: " + (breed.origin ?? "Unknown")
        cell.temperment.text = "Temperment: " + (breed.temperament ?? "Unknown")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

}
