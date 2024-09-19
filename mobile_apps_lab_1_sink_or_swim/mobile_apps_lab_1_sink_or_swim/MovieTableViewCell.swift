//
//  MovieTableViewCell.swift
//  Movie App Bare Bones
//
//  Created by Cameron Tofani on 9/19/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
   //3 things to display for each movie
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "MovieTableViewCell"
    
    //return a cell to configure table (nib is representing a cell)
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    //configuration function:
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.Title
        self.movieYearLabel.text = model.Year
        
        //download contents of url with image
        
        let url = model.Poster
        //this line has errors, idk what it means to use an asynchronous API tho
        if let data = try? Data(contentsOf: URL(string:url)!){
            self.moviePosterImageView.image = UIImage(data:data)
        }
    }
    
}

