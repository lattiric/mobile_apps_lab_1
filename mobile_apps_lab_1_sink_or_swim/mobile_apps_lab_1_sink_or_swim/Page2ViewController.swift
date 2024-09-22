//
//  Page2ViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/19/24.
//

import UIKit
import Foundation

class Page2ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var numberOfMoviesLabel: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    
    //array stores movies from TMDb API
    var movies: [Movie] = []
    
    //TMDb API key
    let apiKey = "c300d8252dfb6ad8789efb1c1abc86c7"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(movies.count, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterCell", for: indexPath) as! MoviePosterCell
            let movie = movies[indexPath.row]
            
            // Configure the cell with the movie's poster path
            cell.configure(with: movie.posterPath)
            
            return cell
    }
    
    struct MovieResponse: Codable
    {
        let results: [Movie]
    }
    
    struct Movie: Codable
    {
        let title: String?
            let posterPath: String?
            let id: Int?
            let overview: String?
            let releaseDate: String?
            
            // Use CodingKeys to map the JSON fields to your struct properties
            enum CodingKeys: String, CodingKey {
                case title
                case posterPath = "poster_path"
                case id
                case overview
                case releaseDate = "release_date"
            }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray;
        
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = 1 // Start with showing one movie

        // Initialize the label to reflect the starting number of movies
        numberOfMoviesLabel.text = "\(Int(stepper.value))"
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        
        collectionView.register(UINib(nibName: "MoviePosterCell", bundle: nil), forCellWithReuseIdentifier: "MoviePosterCell")
//        
//        retrieveNowPlaying()
        Task{
            do{
                let nowPlayingMovies = try await retrieveNowPlaying()
            
                DispatchQueue.main.async {
                    self.movies = nowPlayingMovies
                    self.collectionView.reloadData()
                }
            } catch {
                print("Failed to retrieve now playing movies")
            }
        }
    }
    
    func retrieveNowPlaying() async throws -> [Movie]
    {
        guard let nowPlayingURL = URL(string: "https://api.themoviedb.org/3/movie/now_playing") else {
                throw URLError(.badURL)
            }
        
        guard var components = URLComponents(url: nowPlayingURL, resolvingAgainstBaseURL: true) else {
                throw URLError(.badURL)
            }
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMzAwZDgyNTJkZmI2YWQ4Nzg5ZWZiMWMxYWJjODZjNyIsIm5iZiI6MTcyNzAzODYyMi42MTMxNTIsInN1YiI6IjY2ZWY0MDQ0NGE3ZjBiMThiMDI2MjNlMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.foKTJBnOyutnntMu38h9y8hORJmZhsNhPo4AZe-OCHM"
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from:data)
        
        return movieResponse.results
        //print(String(decoding: data, as: UTF8.self))
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let numberOfMovies = Int(sender.value)
        
        // Update the label with the current number of movies to display
        numberOfMoviesLabel.text = "\(numberOfMovies)"
        
        // Optionally, slice the movies array based on this value
        let displayedMovies = Array(movies.prefix(min(numberOfMovies, 10)))
        
        // Reload the collection view with the updated data
        collectionView.reloadData()
    }
    
    
//        let nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing"
//        
//        guard let url = URL(string:nowPlayingURL) else {  return }
//        
//        let task = URLSession.shared.dataTask(with:url){ [weak self] data, response, error in if let data = data {
//            do {
//                let result = try JSONDecoder().decode(MovieResponse.self, from:data)
//                
//                self?.movies = results.results
//                
//                DispatchQueue.main.async
//                {
//                    self?.collectionView.reloadData()
//                }
//            } catch {
//                print("Error reading JSON")
//            }
//        }
//        }
//    }

    /*
     import Foundation

     let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
     var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
     let queryItems: [URLQueryItem] = [
       URLQueryItem(name: "language", value: "en-US"),
       URLQueryItem(name: "page", value: "1"),
     ]
     components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

     var request = URLRequest(url: components.url!)
     request.httpMethod = "GET"
     request.timeoutInterval = 10
     request.allHTTPHeaderFields = [
       "accept": "application/json",
       "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMzAwZDgyNTJkZmI2YWQ4Nzg5ZWZiMWMxYWJjODZjNyIsIm5iZiI6MTcyNzAzODYyMi42MTMxNTIsInN1YiI6IjY2ZWY0MDQ0NGE3ZjBiMThiMDI2MjNlMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.foKTJBnOyutnntMu38h9y8hORJmZhsNhPo4AZe-OCHM"
     ]

     let (data, _) = try await URLSession.shared.data(for: request)
     print(String(decoding: data, as: UTF8.self))
    */

    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterCell", for: indexPath) as! MoviePosterCell
    //            let movie = movies[indexPath.row]
    //
    //            if let posterPath = movie.posterPath {
    //                let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    //                cell.posterImageView.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "placeholder"))
    //            } else {
    //                cell.posterImageView.image = UIImage(named: "placeholder")
    //            }
    //
    //            return cell
}




/*
 //
 //  MoviePosterCell.swift
 //  mobile_apps_lab_1_sink_or_swim
 //
 //  Created by Shivani Ramkumar on 9/22/24.
 //

 import Foundation
 import UIKit


 class MoviePosterCell: UICollectionViewCell {
     @IBOutlet weak var posterImageView: UIImageView!
     
     public func configure(with posterPath: String?) {
             if let posterPath = posterPath {
                 let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                 loadImage(from: posterUrl)
             } else {
                 posterImageView.image = UIImage(named: "placeholder")
             }
         }
         
     private func loadImage(from url: URL?) {
         guard let url = url else { return }
         
         // Clear the image view before loading a new image
         posterImageView.image = nil
         
         // Create a URLSession data task to fetch the image
         let task = URLSession.shared.dataTask(with: url) { data, response, error in
             if let error = error {
                 print("Error loading image: \(error)")
                 return
             }
             
             guard let data = data, let image = UIImage(data: data) else {
                 return
             }
             
             // Update the image view on the main thread
             DispatchQueue.main.async {
                 self.posterImageView.image = image
             }
         }
         task.resume() // Start the data task
     }
 }

 */
