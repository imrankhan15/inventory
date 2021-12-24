//
//  NewProfileViewController.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 25/11/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log

class NewProfileViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var profiles = [Profile]()
    
    var profile : Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        
        emailTextField.delegate = self
        
        nameTextField.autocorrectionType = .no
        
        emailTextField.autocorrectionType = .no
        
        
        updateSaveButtonState()
        
      
        
        if let savedProfiles = loadProfiles() {
            profiles += savedProfiles
        }
        if profiles.count > 0{
            self.performSegue(withIdentifier: "ShowHome", sender: self)

        }
        else {
            nameTextField.isHidden = false
            emailTextField.isHidden = false
            registerButton.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateSaveButtonState() {
        
        let textForName = nameTextField.text ?? ""
        
        let textForEmail = emailTextField.text ?? ""
        
        registerButton.isEnabled = !textForName.isEmpty && !textForEmail.isEmpty
    }
    
    private func loadProfiles() -> [Profile]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Profile.ArchiveURL.path) as? [Profile]
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func done_action(_ sender: UIButton) {
        
            
            let name = nameTextField.text
            
            
            
            let email = emailTextField.text
            
            
            
            profile = Profile(name: name!, email: email!)
            
            profiles.append(profile!)
        
            saveProfiles()
        
            if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The LoginViewController is not inside a navigation controller.")
            }
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        registerButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
    }
    
    private func saveProfiles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(profiles, toFile: Profile.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
     }
    
    
}


