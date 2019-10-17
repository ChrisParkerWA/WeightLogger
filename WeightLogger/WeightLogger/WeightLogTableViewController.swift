//
//  WeightLogTableViewController.swift
//  WeightLogger
//
//  Created by Tony on 6/19/14.
//  Copyright (c) 2014 Abbouds Corner. All rights reserved.
//

import UIKit
import CoreData


class WeightLogTableViewController: UITableViewController {
    var totalEntries: Int = 0
    
    @IBOutlet var tblView : UITableView?
    
    @IBAction func btnClearLog(sender : AnyObject) {
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        let results = try! context.fetch(request) as NSArray
        
        for weightEntry in results{
            context.delete(weightEntry as! NSManagedObject)
        }
        do {
            try context.save()
        } catch _ {
        }
        totalEntries = 0
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        
        totalEntries =  try! context.count(for: request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // #pragma mark - UITableViewDataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalEntries
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Default")
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        
        let results: NSArray = try! context.fetch(request) as NSArray
        
        //get contents and put into cell
        let thisWeight = results[indexPath.row] as! UserWeights
        cell.textLabel?.text = thisWeight.weight + " " + thisWeight.units
        cell.detailTextLabel?.text = thisWeight.date
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //delete object from entity, remove from list
      
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserWeights")
        request.returnsObjectsAsFaults = false
        
        let results = try! context.fetch(request) as NSArray
        
        //Get value that is being deeleted
        let tmpObject = results[indexPath.row] as! NSManagedObject
        let delWeight = tmpObject.value(forKey: "weight") as? String
        print("Deleted Weight: \(String(describing: delWeight))")
        
        context.delete(results[indexPath.row] as! NSManagedObject)
        do {
            try context.save()
        } catch _ {
        }
        totalEntries = totalEntries - 1
        tableView.deleteRows(at: [indexPath], with: .fade)
        print("Done")
    }
    
    
}
