//
//  StockViewController.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/18/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import CoreData
import MessageUI


class StockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var stocks = [Photos]()
   
    var profiles = [Profile]()
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        if let savedProfiles = loadProfiles() {
            profiles += savedProfiles
        }
       
        
        tableView.separatorStyle = .none
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "inventory.png"))
        tableView.backgroundView?.contentMode = .scaleAspectFit
        
     

        
        tableView.delegate = self
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            stocks = try managedContext.fetch(fetchRequest) as! [Photos]
        } catch {
            print("Fetching Failed")
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonPressed))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Mail Report", style: .plain, target: self, action: #selector(self.mailReport))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonPressed))
        
    }
    
    private func loadProfiles() -> [Profile]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Profile.ArchiveURL.path) as? [Profile]
    }
    
    @objc func mailReport(){
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
          showMailError()
        }
    }
    func configureMailController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([profiles[0].email])
        mailComposerVC.setSubject("Your Inventory")
        var message = "<!DOCTYPE html><html><body> <p>This is your stock.</p>"
        
       
        var image_name = 1
        for stock in stocks {
            let a = stock.value(forKey: "barcode") as! String
            
            
            let b = stock.value(forKey: "desc") as! String
            
            let upload = stock.value(forKey: "upload") as? String
            
            var image = getImageFromPath(sender: upload!)
            
            var newSize: CGSize
            
            newSize = CGSize(width: 200.0, height: 200.0)
            image = self.resizeImage(image:image, targetSize: newSize)
            let imageData = UIImageJPEGRepresentation(image, 1)
            
            mailComposerVC.addAttachmentData(imageData!, mimeType: "image/jpeg", fileName: String(image_name))
           
            image_name = image_name + 1
            
            message += "<p>"+"Barcode: " + a + " Description: " + b + "</p>"
        }
        message += "</body></html>"
        mailComposerVC.setMessageBody(message, isHTML: true)
        
        return mailComposerVC
    }
    
  

    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
    
    func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device cannot send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
            
        
    }
    @objc func editButtonPressed(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.editButtonPressed))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonPressed))
        }
    }

    @IBAction func backHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "StockTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StockTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeListTableViewCell.")
        }
        
        let stock = stocks[indexPath.row]
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        cell.selectionStyle = .none
        
        cell.layer.backgroundColor = UIColor.clear.cgColor

        
        let a = stock.value(forKey: "barcode") as! String
        cell.barcodeLabel.text = "Item Barcode : " + a
        
        let b = stock.value(forKey: "desc") as! String
        
        cell.barcodeDescription.text = "Item Description: "  + b
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let uploadStr = stocks[indexPath.row].value(forKey: "upload") as! String
            
            
            
            
            let fetchPredicate = NSPredicate(format: "upload == %@", uploadStr)
            
            let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
            fetchUsers.predicate                = fetchPredicate
            fetchUsers.returnsObjectsAsFaults   = false
            
             let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchedUsers = try! context.fetch(fetchUsers) as! [NSManagedObject]
            
            for fetchedUser in fetchedUsers {
                
               
                
                context.delete(fetchedUser)
                try! context.save()
            }
            
            removeImage(_sender: uploadStr)
            stocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func removeImage(_sender: String){
        
        let fileNameToDelete = _sender
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
    }
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            
        case "Detail":
            guard let stockDetailViewController = segue.destination as? StockDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            guard let selectedItemCell = sender as? StockTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = stocks[indexPath.row]
            
            stockDetailViewController.stock = selectedItem
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }

    }
   

}
