//  SearchViewController.swift
//  Movie App Bare Bones
//
//  Created by Cameron Tofani on 9/18/24.
//

import UIKit
import SafariServices //to link the website when u click on a movie

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    @IBOutlet var yearPicker: UIPickerView!
    
    //array of movie objects
    var movies = [Movie]()
    var allMovies = [Movie]() // store all movies to reset after filtering
    
    var years = ["All", "Before 2000", "2000-2010", "2010-2020", "2020-2024"] // years for the picker
    var selectedYear: String = "All" // store selected year

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register custom cell
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        
        //set up picker
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        //hide when it first opens, show when search is made
        yearPicker.isHidden = true
        
        //load up keyboard as soon as it opens
        field.becomeFirstResponder()
    }
    
    //picker view methods (pick the year)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;      //only picking from one component
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count // number of year options
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row] // return the year string for each row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = years[row] // update selected year based on one user picks
        filterMovies() // re-filter movies when a new year is selected
    }

    //text field methods (search bar)
    //function to search for a movie
    //capture when user hits return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()    //search for movies when user hits return 
        return true;
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        //encode the search query to be safe for use in the URL (replaces spaces and special characters)
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.omdbapi.com/?apikey=47aeeead&s=\(query)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return   //set url to string
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error or no data")
                return
            }
        
            
            // convert data to MovieResult struct
            do {
                let result = try JSONDecoder().decode(MovieResult.self, from: data)
                self.allMovies = result.Search
                self.movies = result.Search
                
                //testing
                for movie in self.movies {
                    print("Movie Title: \(movie.Title)")
                }
                
                // reload the table on the main thread
                DispatchQueue.main.async {
                    self.yearPicker.isHidden = false
                    self.filterMovies()
                    self.table.reloadData()
                }
            } catch {
                print("Decoding error")
            }
            
        }.resume()
    }

    //function for filtering movies based on picker selection
    func filterMovies() {
        self.movies = self.allMovies
        
        print("Selected Year: \(selectedYear)")
        
        //some formatting is off in json, assure its a 4 dig number
        let yearRegex = try! NSRegularExpression(pattern: "\\d{4}", options: [])
            
            // function to extract the year from the movie's Year string
            func extractYear(from yearString: String) -> Int? {
                let trimmedString = yearString.trimmingCharacters(in: .whitespacesAndNewlines)
                let matches = yearRegex.matches(in: trimmedString, options: [], range: NSRange(location: 0, length: trimmedString.count))
                if let match = matches.first {
                    let yearRange = Range(match.range, in: trimmedString)
                    if let yearRange = yearRange, let year = Int(trimmedString[yearRange]) {
                        return year
                    }
                }
                return nil
            }

            //filter based on picker
            if selectedYear == "All" {
                table.reloadData()  // show all movies
            } else if selectedYear == "Before 2000" {
                let filteredMovies = movies.filter { movie in
                    if let year = extractYear(from: movie.Year), year < 2000 {
                        return true
                    }
                    return false
                }
                self.movies = filteredMovies
                table.reloadData()  //new table with filtered movies
            } else if selectedYear == "2000-2010" {
                let filteredMovies = movies.filter { movie in
                    if let year = extractYear(from: movie.Year), year >= 2000 && year <= 2010 {
                        return true
                    }
                    return false
                }
                self.movies = filteredMovies
                table.reloadData()  // new table
            } else if selectedYear == "2010-2020" {
                let filteredMovies = movies.filter { movie in
                    if let year = extractYear(from: movie.Year), year > 2010 && year <= 2020 {
                        return true
                    }
                    return false
                }
                self.movies = filteredMovies
                table.reloadData()  // new table
            } else if selectedYear == "2020-2024" {
                let filteredMovies = movies.filter { movie in
                    if let year = extractYear(from: movie.Year), year >= 2020 && year <= 2024 {
                        return true
                    }
                    return false
                }
                self.movies = filteredMovies
                table.reloadData()  //new table
            }
    }
    
    //table view for movies (cells for movies)
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

struct MovieResult: Codable {
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
