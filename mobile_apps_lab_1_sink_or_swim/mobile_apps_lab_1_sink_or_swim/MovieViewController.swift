//
//  MovieViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/19/24.
//

import UIKit

class MovieViewController: UIViewController{

    lazy var movieModel = {
        return MovieModel.sharedInstance()
    }()
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    var displayImageName = "Shawshank Redemption"
    
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    /* Scroll View Implementation
     @IBOutlet weak var movieDescription: UILabel!
     lazy private var movieImageView: UIImageView? = {
        return UIImageView.init(image: self.movieModel.getMovieImageWithName(displayImageName))
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.darkGray;
        
        // finds index of movie for other arrays of data
        lazy var movieIndex = 0
        lazy var hitMovieLocation = false
        for movieName in movieModel.movieNames {
            if(movieName as! String == displayImageName){
                hitMovieLocation = true
            }
            if(!hitMovieLocation){
                movieIndex = movieIndex+1
            }
        }
        
        self.movieImageView.image = UIImage.init(named: displayImageName)
        self.movieLabel.text = displayImageName;
        if let desc = movieModel.movieDescs[movieIndex] as? String{
            self.movieDescription.text = desc
        }
//        self.scrollView.addSubview(self.movieImageView!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
