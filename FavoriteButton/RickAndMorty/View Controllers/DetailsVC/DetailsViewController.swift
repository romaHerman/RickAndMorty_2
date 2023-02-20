//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Andrii Stetsenko on 07.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationNamLabele: UILabel!
    @IBOutlet weak var locationURLLabel: UILabel!
    
    
    // MARK: - Properties
    var rickAndMortyData: RickAndMortyData?
    var currentCharacter: Int = 0
    var favoriteStatus = false
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        setUpFavoriteButton()
    }
    
    
    // MARK: - Private functions
    private func setUpFavoriteButton() {
        let favoriteBtn = UIButton(type: .custom)
        favoriteBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        favoriteBtn.setImage(UIImage(systemName:"heart.fill"), for: .normal)
        favoriteBtn.tintColor = favoriteStatus ? .systemRed : .lightGray
        favoriteBtn.tag = rickAndMortyData?.results[currentCharacter].id ?? 0
        favoriteBtn.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        
        let favoriteBarButton = UIBarButtonItem(customView: favoriteBtn)
        navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        print("Sender tag from DetailsViewController - \(sender.tag) !!!!")
        favoriteStatus.toggle()
        sender.tintColor = favoriteStatus ? .systemRed : .lightGray
        
        Favorites.shared.toggleFavorite((rickAndMortyData?.results[currentCharacter])!)
    }

    private func loadData() {
        let item = rickAndMortyData?.results[currentCharacter]
        nameLabel.text = item?.name
        idLabel.text = "id: \(item?.id ?? 0)"
        statusLabel.text = "status: \(item?.status.rawValue ?? "error")"
        speciesLabel.text = "species: \(item?.species.rawValue ?? "error")"
        genderLabel.text = "gender: \(item?.gender.rawValue ?? "error")"
        locationNamLabele.text = "location name: \(item?.location.name ?? "error")"
        locationURLLabel.text = "location URL: \(item?.location.url ?? "error")"
        
        guard let urlString = item?.image else { return }
        
        pictureImage.loadImageFrom(urlString: urlString)
    }
    
}
