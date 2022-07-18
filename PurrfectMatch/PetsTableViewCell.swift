//
//  StudentTableViewCell.swift
//  StudentApp
//
//  Created by Kely Sotsky on 06/04/2022.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var name = "" {
        didSet{
            if(nameLabel != nil){
                nameLabel.text = name
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = name
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
