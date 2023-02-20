//
//  NetworkRickAndMortyManager.swift
//  RickAndMorty
//
//  Created by Andrii Stetsenko on 04.12.2022.
//

import Foundation

struct NetworkRickAndMortyManager {
    
    var onCompletionRickAndMortyComicsData: ((RickAndMortyData) -> Void)?
    
    func getData() {
        let urlString = "https://rickandmortyapi.com/api/character"
        getURL(string: urlString)
    }
    
    func getData(from id: Int) {
        let urlString = "https://rickandmortyapi.com/api/character/\(id)"
        getURL(string: urlString)
    }
    
    //?
    func getDataName() {
        let urlString = "https://rickandmortyapi.com/api/character/?page=2&name=rick&status=alive"
        getURL(string: urlString)
    }
    
    func getURL(string: String) {
        guard let url = URL(string: string) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentData = self.parseRickAndMortyJSON(withData: data) {
                    self.onCompletionRickAndMortyComicsData?(currentData)
                    print("TEST: \(currentData.results.count)")
                }
            }
        }
        task.resume()
    }
    
    func parseRickAndMortyJSON(withData data: Data) -> RickAndMortyData? {
        let decoder = JSONDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let decodedRickAndMortyData = try decoder.decode(RickAndMortyData.self, from: data)
            print("Count: \(decodedRickAndMortyData.info.count)")
            return decodedRickAndMortyData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
