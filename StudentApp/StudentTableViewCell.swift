//
//  StudentTableViewCell.swift
//  StudentApp
//
//  Created by Kely Sotsky on 06/04/2022.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var id = "" {
        didSet{
            if(idLabel != nil){
                idLabel.text = id
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        idLabel.text = id
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
