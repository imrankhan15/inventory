//
//  HomeViewController.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import CoreData


class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var takePicture: UIButton!
    
    
    var photos = [Photos]()
    
    var tableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableData = [String]()
        
        tableData.append("Egg Benedict")
        
        takePicture.backgroundColor = UIColorFromRGB(rgbValue: 0xDC2429)
        
        takePicture.titleColor(for: .normal)
        
        takePicture.layer.cornerRadius = 4.0
        
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        
        do {
            photos = try context.fetch(fetchRequest) as! [Photos]
            
            tableView.reloadData()
            
            tableView.separatorStyle = .none
            
            
        } catch {
            print("Fetching Failed")
        }
        
        self.navigationItem.title = "Home"
        
        
    }
    
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        
        
    }
    
    @IBAction func takePictureAction(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableData = [String]()
        
        tableData.append("Egg Benedict")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        
        do {
            photos = try context.fetch(fetchRequest) as! [Photos]
            
            tableView.reloadData()
            
            tableView.separatorStyle = .none
            
            
        } catch {
            print("Fetching Failed")
        }
        
        
        
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SimpleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SimpleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeListTableViewCell.")
        }
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        cell.selectionStyle = .none
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        
        var counter = 0;
        
        for photo in photos{
            
            var uploadString = String(describing: photo.value(forKey: "upload"))
            
            if(uploadString.characters.count > 3){
                counter = counter + 1
            }
        }
        
        let pending = counter.description + " products in the inventory"
        
        cell.lbl_name.textColor = UIColorFromRGB(rgbValue: 0x676767)
        
        cell.lbl_name.text = pending
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowStock":
            
            guard let navVc = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let stockViewController = navVc.viewControllers.first as! StockViewController
            
            
            
            
        default: break
            
            
        }
    }
    
    
}

extension Int {
    func square() -> Int {
        return self * self 
    }
}
