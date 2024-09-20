//
//  SearchViewController.swift
//  Movie App Bare Bones
//
//  Created by Cameron Tofani on 9/18/24.
//

import UIKit
import SafariServices //to link the website when u click on a movie

//WHAT WE NEED:
//UI
//Network Request
//Need a way to tap a cell to see info about the movie
//custom cell to show the movie

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    //array of movie objects
    var movies = [Movie]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        
        //load up keyboard as soon as it opens
        field.becomeFirstResponder()
    }
    
    //Field
    //function to search for a movie
    //capture when user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies();
        return true;
    }
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        // Clear previous search results
        movies.removeAll()
        
        //encode the search query to be safe for use in the URL (replaces spaces and special characters)
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.omdbapi.com/?apikey=47aeeead&s=\(query)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error or no data")
                return
            }
            
            
            
            //TESTING
//            if let jsonString = String(data: data, encoding: .utf8) {
//                        print("JSON Response: \(jsonString)")
//                    }
            
            // Convert data to MovieResult struct
            do {
                let result = try JSONDecoder().decode(MovieResult.self, from: data)
                self.movies = result.Search
                
                //testing
                for movie in self.movies {
                    print("Movie Title: \(movie.Title)")
                    }
                
                // Reload the table on the main thread
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch {
                print("Decoding error")
            }
            
        }.resume()
    }
    
    
    //Table
    //function for num rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        cell.configure(with: movies[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //to show movie details
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string:url)!)
        present(vc, animated: true)
        
    }

}
struct MovieResult: Codable{
    let Search: [Movie]
}

struct Movie: Codable {  //what its looking for in the json
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }

}


