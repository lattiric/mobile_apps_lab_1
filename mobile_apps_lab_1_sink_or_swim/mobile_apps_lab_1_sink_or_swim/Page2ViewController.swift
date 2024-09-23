//
//  Page2ViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/19/24.
//

import UIKit
import Foundation

class Page2ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //outlets/connections from Main storyboard
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var numberOfMoviesLabel: UILabel!
    
    @IBOutlet var stepper: UIStepper!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var horStackView: UIStackView!
    
    //array stores movies from TMDb API
    var movies: [Movie] = []
    
    //TMDb API key
    let apiKey = "c300d8252dfb6ad8789efb1c1abc86c7"
    
    //the CollectionView will hold the number of items as dictated by the user when using the stepper
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(movies.count, Int(stepper.value))
    }
    
    //the CollectionView will
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
        stepper.stepValue = 1.0 // Start with showing one movie
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:60, height:100)
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
                    self.loadImagesForScrollView(stepperValue: Int(self.stepper.value))
                }
            } catch {
                print("Failed to retrieve now playing movies")
            }
        }
        
        
        // Initialize UIScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        // Initialize UIStackView to hold images
        horStackView = UIStackView()
        horStackView.translatesAutoresizingMaskIntoConstraints = false
        horStackView.axis = .horizontal
        
        scrollView.addSubview(horStackView)
        view.addSubview(scrollView)

        // Set up scroll view constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            scrollView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Set up stack view constraints inside scroll view
        NSLayoutConstraint.activate([
            horStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            horStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            horStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        // Load images into the scroll view
        loadImagesForScrollView(stepperValue: Int(stepper.value))
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
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        numberOfMoviesLabel.text = Int(sender.value).description
        
        collectionView.reloadData()
        loadImagesForScrollView(stepperValue: Int(sender.value))
    }
    
    func loadImagesForScrollView(stepperValue: Int) {
        // Clear existing images from the stack view
        horStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let numberOfMoviesToShow = min(movies.count, stepperValue)
            
            // Loop over the number of movies to show based on stepper value
            for index in 0..<numberOfMoviesToShow {
                let movie = movies[index]
                
                // Create an image view for each movie poster
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true

                // Load the movie poster image
                if let posterPath = movie.posterPath {
                    let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                    loadImage(from: posterUrl, into: imageView)
                } else {
                    imageView.image = UIImage(named: "placeholder")
                }

                // Create a zoomable view for each image
                let zoomableView = createZoomableView(with: imageView)
                horStackView.addArrangedSubview(zoomableView)
                
                
                // Set width and height constraints for the image view
                zoomableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        }
    }

    // Helper function to load an image asynchronously
    func loadImage(from url: URL?, into imageView: UIImageView) {
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
    
    
    func createZoomableView(with imageView: UIImageView) -> UIScrollView {
        let zoomableScrollView = UIScrollView()
        zoomableScrollView.translatesAutoresizingMaskIntoConstraints = false
        zoomableScrollView.delegate = self
        zoomableScrollView.minimumZoomScale = 0.5
        zoomableScrollView.maximumZoomScale = 2.0

        zoomableScrollView.addSubview(imageView)
        
        // Add constraints to the image view inside the zoomable scroll view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: zoomableScrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: zoomableScrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: zoomableScrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: zoomableScrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: zoomableScrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: zoomableScrollView.heightAnchor)
        ])
        
        return zoomableScrollView
    }

    // Implement UIScrollViewDelegate method for zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first(where: { $0 is UIImageView }) as? UIImageView
    }
    
}

