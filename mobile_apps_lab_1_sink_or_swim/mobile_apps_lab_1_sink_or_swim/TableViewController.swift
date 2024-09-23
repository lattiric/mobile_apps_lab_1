//
//  TableViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/18/24.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray;
    }
    
    lazy var movieModel:MovieModel = {
        return MovieModel.sharedInstance()
    }()
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 1 {
            if(self.movieModel.movieNames.count > 10) {
                return 10
            }
            return self.movieModel.movieNames.count
        }else{
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieNameCell", for: indexPath)
            // Configure the cell...
            if let name = self.movieModel.movieNames[indexPath.row] as? String{
                cell.textLabel!.text = name
            }
            
            return cell
        }else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell", for: indexPath)
            // Configure the cell...
            cell.textLabel?.text = "Movie Search"
            cell.detailTextLabel?.text = "TODO: # of movies"
            cell.backgroundColor = UIColor.lightGray
            
            cell.textLabel?.layer.borderColor = UIColor.gray.cgColor
                cell.textLabel?.layer.borderWidth = 1
                cell.textLabel?.layer.cornerRadius = 5
                cell.textLabel?.layer.masksToBounds = true
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreditsCell", for: indexPath)
            // Configure the cell...
            cell.textLabel?.text = "Roll Credits"
            cell.detailTextLabel?.text = "4"
            cell.backgroundColor = UIColor.darkGray
            
            return cell
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if let vc = segue.destination as? MovieViewController,
           let cell = sender as? UITableViewCell,
           let name = cell.textLabel?.text{
                vc.displayImageName = name
        }
        
    }
    

}
