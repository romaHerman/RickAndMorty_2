//
//  CharactersTableViewController.swift
//  RickAndMorty
//
//  Created by Andrii Stetsenko on 04.12.2022.
//

import UIKit

class CharactersTableViewController: UITableViewController {
    
    // MARK: - Properties
    var networkRickAndMortyManager = NetworkRickAndMortyManager()
    var rickAndMortyData: RickAndMortyData?
    var favorites = Favorites()
    var currentCharacter: Int = 0
    
    var isFilterMenuNameActive: Bool = false
    var isFavoriteMenuActive: Bool = false
    var favoriteStatus: Bool = false
    
    var results: [Result] = []
    var filteredResults: [Result] = []
    var favoriteResults: [Result] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    let identifier = "CharactersCell"
    let charactersDetailsIdentifier = "ShowCharactersDetailsVC"
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        loadRickAndMortyData()
        navigationItemMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Private functions
    private func loadRickAndMortyData() {
        networkRickAndMortyManager.onCompletionRickAndMortyComicsData = { [weak self] rickAndMortyData in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.rickAndMortyData = rickAndMortyData
                self.results.append(contentsOf: rickAndMortyData.results)
                self.tableView.reloadData()
            }
        }
        networkRickAndMortyManager.getData()
    }
    
    private func navigationItemMenu() {
        let nameItem = UIAction(title: "name") { (action) in
            print("filtering by name")
            
            if self.isFilterMenuNameActive {
                self.isFilterMenuNameActive = false
                print("filterMenuNameActive - false")
                
                self.tableView.reloadData()
            } else {
                self.isFilterMenuNameActive = true
                print("filterMenuNameActive - true")
                
                self.filteredResults = self.results.sorted { $0.name < $1.name }
                self.tableView.reloadData()
            }
        }
        
        let aliveItem = UIAction(title: "alive") { (_) in
        }
        
        let deadItem = UIAction(title: "dead") { (_) in
        }
        
        let unknownStatusItem = UIAction(title: "unknown") { (_) in
        }
        
        let speciesItem = UIAction(title: "species") { (_) in
        }
        
        let typeItem = UIAction(title: "type") { (_) in
        }
        
        let femaleItem = UIAction(title: "female") { (_) in
        }
        
        let maleItem = UIAction(title: "male") { (_) in
        }
        
        let genderlessItem = UIAction(title: "genderless") { (_) in
        }
        
        let unknownGenderItem = UIAction(title: "unknown") { (_) in
        }
        
        let favoriteItem = UIAction(title: "Favorite", image: UIImage(systemName: "heart")) { (_) in
            print("filtering by Favorite")
            
            if self.isFavoriteMenuActive {
                self.isFavoriteMenuActive = false
                print("filterMenuNameActive - false")
                
                self.tableView.reloadData()
            } else {
                self.isFavoriteMenuActive = true
                print("filterMenuNameActive - true")
                
                self.filteredResults = self.favoriteResults.sorted { $0.name < $1.name }
                self.tableView.reloadData()
            }
        }
        
        var submenuStatus: UIMenu {
            return UIMenu(title: "status", image: UIImage(systemName: "ellipsis"), children: [aliveItem, deadItem, unknownStatusItem])
        }
        
        var submenuGender: UIMenu {
            return UIMenu(title: "gender", image: UIImage(systemName: "ellipsis"), children: [femaleItem, maleItem, genderlessItem, unknownGenderItem])
        }
        
        var menu: UIMenu {
            return UIMenu(title: "Sort by", options: [.singleSelection], children: [nameItem, submenuStatus, speciesItem, typeItem, submenuGender, favoriteItem])
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", primaryAction: nil, menu: menu)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredResults.count
        }
        
        if isFilterMenuNameActive {
            return filteredResults.count
        }
        
        if isFavoriteMenuActive {
            return favoriteResults.count
        }
        
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CharactersTableViewCell {
            if isFiltering || isFilterMenuNameActive {
                let filteredResultsItem = filteredResults[indexPath.row]
                let urlString = filteredResultsItem.image
                
                cell.configure(with: filteredResultsItem, url: urlString, favoriteStatus: favorites.isFavorite(filteredResultsItem))
                
                return cell
            } else if isFavoriteMenuActive {
                let favoriteItem = favoriteResults[indexPath.row]
                let urlString = favoriteItem.image
                
                cell.configure(with: favoriteItem, url: urlString, favoriteStatus: favorites.isFavorite(favoriteItem))
                
                return cell
            } else {
                let resultsItem = results[indexPath.row]
                let urlString = resultsItem.image
                
                cell.configure(with: resultsItem, url: urlString, favoriteStatus: favorites.isFavorite(resultsItem))
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    // сделаем так что после появления ячейки внизу не будет лишних видимых ячеек (сетки). Добавим два метода Футера.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == charactersDetailsIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                if isFiltering || isFilterMenuNameActive {
                    let filteredResultsItem = filteredResults[indexPath.row]
                    self.currentCharacter = filteredResultsItem.id - 1
                } else if isFavoriteMenuActive {
                    let favoriteItem = favoriteResults[indexPath.row]
                    self.currentCharacter = favoriteItem.id - 1
                } else {
                    let resultsItem = results[indexPath.row]
                    self.currentCharacter = resultsItem.id - 1
                }
                
                let detailVC = segue.destination as! DetailsViewController
                detailVC.title = "Character details"
                detailVC.currentCharacter = self.currentCharacter
                detailVC.rickAndMortyData = self.rickAndMortyData
                detailVC.favoriteStatus = self.isFavoriteMenuActive
            }
        }
    }
    
}


// MARK: - UISearchResultsUpdating Delegate
extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
        filterSortByName(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredResults = results.filter({ (result: Result) -> Bool in
            return result.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func filterSortByName(_ searchText: String) {
        //filteredResults = results.sorted { $0.name < $1.name }
        filteredResults = results.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
        
        tableView.reloadData()
    }
}

