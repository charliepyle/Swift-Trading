//
//  SearchNavigation.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI


class SearchBar: NSObject, ObservableObject {
    
    @Published var text: String = ""
    @Published var searchResults:[StockSearch] = []
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
    }
}

extension SearchBar: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
            if (searchBarText.count >= 3) {
                getSearchResults()
            }
        }
    }
    
    func getSearchResults() {
        
        guard let url = URL(string: "https://hw8-usc.wl.r.appspot.com/api/autocomplete/\(self.text)")
        else {
            print("Bad URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode([StockSearch].self, from: data) {
                            DispatchQueue.main.async {
                                self.searchResults = response
                            }
                            return
                        }
                    }
                }.resume()
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}
