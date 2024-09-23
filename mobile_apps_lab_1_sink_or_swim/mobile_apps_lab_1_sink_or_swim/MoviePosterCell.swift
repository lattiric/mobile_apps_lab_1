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
    
    static func nib() -> UINib
    {
        return UINib(nibName: "MoviePosterCell", bundle: nil)
    }
}
