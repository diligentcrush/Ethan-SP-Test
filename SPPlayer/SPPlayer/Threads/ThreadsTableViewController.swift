//
//  ThreadsTableViewController.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/21/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import Kingfisher
class ThreadsTableViewController: UITableViewController {

    var threads : [String] = []
    let baseURL = "https://api.spotify.com/v1/tracks/"
    
    var appRemote: SPTAppRemote {
        get {
            return (UIApplication.shared.delegate as? AppDelegate)!.appRemote
        }
    }
    
    func requestingTrack(accessToken: String, trackID : String, completion: @escaping (Track) -> Void){
        let headers: [String: String] = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        Alamofire.request(baseURL+trackID, headers: headers).responseObject { (response: DataResponse<Track>) in
            if let value = response.result.value {
                completion(value)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "pause", style: .done, target: self, action: #selector(pause))
        
    }
    @objc func pause(){
        appRemote.playerAPI?.pause(nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return threads.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadsCell", for: indexPath) as! ThreadTableViewCell
        
        if let accessToken = UserDefaults.standard.string(forKey: "access-token-key"){
            let trackID = threads[indexPath.row].components(separatedBy: ":")[2]
            requestingTrack(accessToken: accessToken, trackID: trackID) { (track) in
                cell.threadMsg.text = track.name
                let url = URL(string: track.album?.images?.first?.url ?? "https://picsum.photos/200")!
                cell.trackImg.kf.setImage(with: url)
                print(track.toJSONString())
            }
      
            
        }
        return cell
    }
    
    func parseOutTrackID(_ meta : String)->String{
        let arr = meta.components(separatedBy: ":")
        let result = "spotify:\(arr[1]):\(arr[2])"
        return result
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(appRemote.isConnected) {
            if (!appRemote.authorizeAndPlayURI(parseOutTrackID(threads[indexPath.row]))) {
                // The Spotify app is not installed, present the user with an App Store page
                //showAppStoreInstall()
            }
        }
        else {
            appRemote.playerAPI?.play(parseOutTrackID(threads[indexPath.row]), callback: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
