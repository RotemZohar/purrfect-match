//
//  StarWarsTableViewCell.swift
//  StudentApp
//
//  Created by Eliav Menachi on 08/06/2022.
//

import UIKit

class StarWarsTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var episod: UILabel!
    @IBOutlet weak var filmTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
