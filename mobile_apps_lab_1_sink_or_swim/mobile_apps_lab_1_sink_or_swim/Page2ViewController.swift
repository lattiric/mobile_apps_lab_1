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
    
    @IBOutlet var numberOfMoviesLabel: UILabel!
    
    @IBOutlet var stepper: UIStepper!
    
    
    //array stores movies from TMDb API
    var movies: [Movie] = []
    
    //TMDb API key
    let apiKey = "c300d8252dfb6ad8789efb1c1abc86c7"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return min(movies.count, 10)
        return min(movies.count, Int(stepper.value))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterCell", for: indexPath) as! MoviePosterCell
        let movie = movies[indexPath.row]
        
        // Configure the cell with the movie's poster path
        cell.configure(with: movie.posterPath)
        //cell.configure(with: (movie.posterPath)!)
        
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
        //stepper.value = 1
        stepper.stepValue = 1.0 // Start with showing one movie
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:120, height:300)
        collectionView.collectionViewLayout = layout
        
        // Initialize the label to reflect the starting number of movies
        numberOfMoviesLabel.text = "\(Int(stepper.value))"
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "MoviePosterCell", bundle: nil), forCellWithReuseIdentifier: "MoviePosterCell")
        
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
        numberOfMoviesLabel.text = Int(sender.value).description
        
        collectionView.reloadData()
    }
}

