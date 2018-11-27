//
//  GroupsTableViewController.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/20/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

class GroupsTableViewController: UITableViewController {

    var dic : [String : [String]] = CoreFunc.retrieveDict()
    let baseURL = "https://api.spotify.com/v1/tracks/"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
    }
    
    func getTimestamp(_ data:String)->Int64{
        let arr = data.components(separatedBy: ":")
        if let num = Int64(arr.last!) {
            return num
        }
        return 0
    }
    func getTrackID(_ data: String)->String{
        return data.components(separatedBy: ":")[2]
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dic.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        
        if let accessToken = UserDefaults.standard.string(forKey: "access-token-key"){
            let dataArray = dic[Array(dic.keys)[indexPath.row]]
            if let first = dataArray?.first{
                requestingTrack(accessToken: accessToken, trackID: getTrackID(first)) { (track) in
                    cell.groupName.text = Array(self.dic.keys)[indexPath.row]
                    cell.timestamp.text = timeAgoSinceDate(date: Date(timeIntervalSince1970: TimeInterval(self.getTimestamp(first))) as NSDate, numericDates: false)
                    cell.songDataPreview.text = track.artists?.first?.name
                    
                }
            }
  
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let threads = dic[Array(dic.keys)[indexPath.row]] {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Threads", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "threadsTVC") as! ThreadsTableViewController
            nextViewController.threads = threads
            nextViewController.title = Array(dic.keys)[indexPath.row]
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        
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
