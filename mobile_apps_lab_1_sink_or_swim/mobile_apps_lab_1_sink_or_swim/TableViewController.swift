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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.movieModel.movieNames.count > 10) {
            return 10
        }
        
        return self.movieModel.movieNames.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieNameCell", for: indexPath)

        // Configure the cell...
        if let name = self.movieModel.movieNames[indexPath.row] as? String{
            cell.textLabel!.text = name
        }
        
        return cell
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
