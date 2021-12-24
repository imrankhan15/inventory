//
//  Profile.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 25/11/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log

class Profile: NSObject, NSCoding {
    
    var name: String
    var email: String
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("profiles")
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let email = "email"
    }
    //MARK: Initialization
    init?(name: String, email: String) {
        guard !name.isEmpty else {
            return nil
        }
        guard !email.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.email = email
    }
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(email, forKey: PropertyKey.email)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Profile object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String else {
            os_log("Unable to decode the email for a Profile object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, email: email)
        
    }

    

}
