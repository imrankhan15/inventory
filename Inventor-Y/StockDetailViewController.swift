//
//  StockDetailViewController.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/20/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import CoreData


class StockDetailViewController: UIViewController {
    
    var stock = Photos()

    
    @IBOutlet weak var barcode: UILabel!
    
    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let barcodeString = stock.value(forKey: "barcode") as! String
        
       
        
        let detailsString = stock.value(forKey: "desc") as! String
        
        
        barcode.text = " Barcode: " + barcodeString
        
        Details.text = " Details: " + detailsString
        
        let upload = stock.value(forKey: "upload") as? String
        
        let image = getImageFromPath(sender: upload!)
        
        imgView.image = image
        
        // Do any additional setup after loading the view.
    }
    
    func getImageFromPath(sender: String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        var image = UIImage()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(sender)
            image    = UIImage(contentsOfFile: imageURL.path)!
            
            return image
            // Do whatever you want with the image
        }
        
        return image
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
  

}
