//
//  ViewController.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/23/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var screenNameField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       loginLabel.text = ""
    }


    @IBAction func joinBtnPressed(_ sender: Any) {
        if let screenName = screenNameField.text {
            FirebaseClient.tryLogin(name: screenName, success: {result, message in
                self.loginLabel.text = message
                guard result == true else {return}
                UserDefaults.standard.set(screenName, forKey: "screenName")
                self.performSegue(withIdentifier: "openChannel", sender: self)
                User.setCurrentUserName(as: screenName)
            })
        }
        
    }

}

