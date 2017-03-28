//
//  InboxViewController.swift
//
//
//  Created by Johann Kerr on 3/23/17.
//
//
import Foundation
import UIKit
import Firebase

class ChannelViewController: UITableViewController {
    
    
    
    var channels = [Channel]()
    var user: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseClient.getChannels(then: {fireChannels in
            DispatchQueue.main.async {
                self.channels = []
                self.tableView.reloadData()
                self.channels = fireChannels
                self.tableView.reloadData()
            }
        })
    }
    
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "msgSegue",
            let dest = segue.destination as? MessageViewController
            else {return}
        if let index = self.tableView.indexPathForSelectedRow?.row {
            let channel = self.channels[index].name
            dest.channelId = channel
            dest.senderId = user
            dest.senderDisplayName = user
            FirebaseClient.joinChannel(name: channel)
        }
        
    }
    
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Create Channel", message: "Create a new channel", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Channel Name"
        }
        
        let create = UIAlertAction(title: "Create", style: .default) { (action) in
            if let channel = alertController.textFields?[0].text {
                FirebaseClient.addChannel(name: channel, then:{self.tableView.reloadData()})
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(create)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
 
}


extension ChannelViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath)
        let cellChannel = channels[indexPath.row]
        cell.textLabel?.text = "\(cellChannel.name) (\(cellChannel.numberOfParticipants))"
        cell.detailTextLabel?.text = cellChannel.lastMsg
        
        
        return cell
    }
    
}
