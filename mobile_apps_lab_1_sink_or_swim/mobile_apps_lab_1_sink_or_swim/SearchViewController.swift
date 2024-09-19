//
//  SearchViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/19/24.
//

import UIKit
import SafariServices //to link the website when u click on a movie

class SearchViewController: UIViewController,  UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!
    //@IBOutlet var field: UITextField!
    
    //array of movie objects
    var movies = [Movie]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier:
                        MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        //field.delegate = self
        
        //load up keyboard as soon as it opens
        fetchTopMovies()
    }
    
    func fetchTopMovies(){
        let urlString = "https://www.omdbapi.com/?apikey=47aeeead&s=superman"
        
        //make sure its a valid string
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error or no data")
                return
            }
            
            
            // decode jason into MovieResult struct
            do {
                let result = try JSONDecoder().decode(MovieResult.self, from: data)
                //stored in movies array ONLY 15
                self.movies = Array(result.Search.prefix(15))
                
                //testing
                for movie in self.movies {
                    print("Movie Title: \(movie.Title)")
                    }
                
              //update the UI
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch {
                print("Decoding error")
            }
            
        }.resume()
    }
    
    
    //Table
    //UItableview uses movies array to populate rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //each cell made with movies poster and title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //use same cells once they scroll past
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        //method from MovieTableView class, sets up cell with data from movies array
        cell.configure(with: movies[indexPath.row])
        return cell;
    }
    
    //action for selecting a movie
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //to show movie details when tapped on
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
