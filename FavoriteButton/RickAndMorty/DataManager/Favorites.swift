//
//  Favorites.swift
//  RickAndMorty
//
//  Created by Andrii Stetsenko on 17.02.2023.
//

import Foundation

class Favorites {
    static let shared = Favorites()
    
    let defaults = UserDefaults.standard
    var favorites: Set<Int>
    
    init() {
        favorites = []
    }
    
    var results: [Result] {
        get {
            if let data = defaults.value(forKey: "results") as? Data {
                guard let decoded = try? PropertyListDecoder().decode([Result].self, from: data) else { return [Result]()}
                
                return decoded.sorted { $0.name < $1.name }
            } else {
                return [Result]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "results")
            }
        }
    }
    
    func isFavorite(_ result: Result) -> Bool {
        favorites.contains(result.id)
    }
    
    func toggleFavorite(_ result: Result) {
        if favorites.contains(result.id) {
            favorites.remove(result.id)
        } else {
            favorites.insert(result.id)
        }
        
        UserDefaults.standard.set(Array(favorites), forKey: "results")
    }
}
