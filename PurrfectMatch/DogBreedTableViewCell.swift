//
//  StarWarsTableViewCell.swift
//  PurrfectMatch
//
//  Created by admin on 08/06/2022.
//

import UIKit

class DogBreedTableViewCell: UITableViewCell {

    @IBOutlet weak var temperment: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var lifeSpan: UILabel!
    @IBOutlet weak var breedName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
