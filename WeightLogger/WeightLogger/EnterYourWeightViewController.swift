//
//  EnterYourWeightViewController.swift
//  WeightLogger
//
//  Created by Tony on 6/19/14.
//  Copyright (c) 2014 Abbouds Corner. All rights reserved.
//

import UIKit
import CoreData


class EnterYourWeightViewController: UIViewController {
    
    
    @IBOutlet var txtWeight : UITextField!
    @IBOutlet var units : UISwitch!
    
    @IBAction func btnSavePressed(sender: AnyObject) {
        if let weight = txtWeight.text{
            if weight.isEmpty == false{
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                let context: NSManagedObjectContext = appDel.managedObjectContext
                let ent = NSEntityDescription.entity(forEntityName: "UserWeights", in: context)!
                
                //Instance of our custom class, reference to entity
                let newWeight = UserWeights(entity: ent, insertInto: context)
                
                //Fill in the Core Data
                newWeight.weight = weight
                if (units.isOn) {
                    newWeight.units = "lbs"
                } else {
                    //Switch is off
                    newWeight.units = "kgs"
                }
                
                let dateFormatter = DateFormatter()
                let curLocale: NSLocale = Locale.current as NSLocale
                let formatString: NSString = DateFormatter.dateFormat(fromTemplate: "EdMMM h:mm a", options: 0, locale: curLocale as Locale)! as NSString
                dateFormatter.dateFormat = formatString as String
                newWeight.date = dateFormatter.string(from: NSDate() as Date)
                
                do {
                    try context.save()
                } catch {
                }
            }else{
                //User carelessly pressed save button without entering weight.
                let alert = UIAlertController(title: "No Weight Entered", message: "Enter your weight before pressing save.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(result)in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            print("No element text for the UITextField 'txtWeight'")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        txtWeight.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
