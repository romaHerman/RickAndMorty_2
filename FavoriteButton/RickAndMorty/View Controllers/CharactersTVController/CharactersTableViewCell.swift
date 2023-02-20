//
//  CharactersTableViewCell.swift
//  RickAndMorty
//
//  Created by Andrii Stetsenko on 04.12.2022.
//

import UIKit

class CharactersTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    
    // MARK: - Properties
    //var favoriteStatus = false

    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    
    // MARK: - Private functions
    func configure(with result: Result, url: String, favoriteStatus: Bool) {
        idLabel.text = "\(result.id)"
        nameLabel.text = result.name
        statusLabel.text = result.status.rawValue
        speciesLabel.text = result.species.rawValue
        genderLabel.text = result.gender.rawValue
        favoriteImage.tintColor = favoriteStatus ? .systemRed : .lightGray
        
        pictureImage.loadImageFrom(urlString: url)
    }
    
}
