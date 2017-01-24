//
//  TableViewController.swift
//  destinations
//
//  Created by Sacchit Chadha  on 06/06/16.
//  Copyright © 2016 Sacchit Chadha . All rights reserved.
//

import UIKit

var places = [Dictionary<String,String>()]
var place = -1

class TableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if places.count == 1
        {
            places.remove(at: 0)
            if UserDefaults.standard.object(forKey: "places") != nil
            {
                places = UserDefaults.standard.object(forKey: "places") as! [Dictionary<String,String>];
            }

            if places.count == 0
            {
                places.append(["name":"Taj Mahal", "latitude":"27.175277", "longitude":"78.042128"])
                UserDefaults.standard.set(places, forKey: "places")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = places[indexPath.row]["name"]
        
        cell.textLabel?.textColor = UIColor.init(red:84/255, green:95/255, blue:102/255, alpha: 1.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.set(places, forKey: "places")
            
            table.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        place = indexPath.row
        
        return indexPath
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        table.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPlace"
        {
            place = -1
        }
    }
}
