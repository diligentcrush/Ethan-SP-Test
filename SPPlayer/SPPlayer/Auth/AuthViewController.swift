//
//  ViewController.swift
//  SPPlayer
//
//  Created by Eduardo Irias on 11/2/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    fileprivate let trackIdentifier = "spotify:track:6XZLlfwcvmM2LSobNGfvzM"
    
    var appRemote: SPTAppRemote {
        get {
            return (UIApplication.shared.delegate as? AppDelegate)!.appRemote
        }
    }
    
    fileprivate var playerState: SPTAppRemotePlayerState?


    @IBOutlet weak var playButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playButton.setTitle("Loading", for: UIControl.State.normal)
        playButton.isEnabled = false
        
        
        print("lmaooooo")
        let dict = CoreFunc.retrieveDict()
        for (grpName, grpList) in dict {
            print("grpName: \(grpName)")
            print("grpList: \(grpList)")
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(appRemoteConnected), name: NSNotification.Name.appRemoteDidEstablishConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appRemoteNotConnected), name: NSNotification.Name.didFailConnectionAttemptWithError, object: nil)
    }
   
    
    @objc func appRemoteNotConnected() {
        self.playButton.setTitle("Connect", for: UIControl.State.normal)
        playButton.isEnabled = true
    }
    
    @objc func appRemoteConnected() {
        appRemote.playerAPI!.delegate = self
        appRemote.userAPI!.delegate = self
        
        self.playButton.setTitle("Go to Groups", for: UIControl.State.normal)
        playButton.isEnabled = true
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Groups", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "groupsTVC") as! GroupsTableViewController
//        nextViewController.dic = CoreFunc.retrieveDict()
//        self.navigationController?.pushViewController(nextViewController, animated:true)

    }

    @IBAction func authToSpotify(_ sender: Any) {
        if !(appRemote.isConnected) {
            if (!appRemote.authorizeAndPlayURI(trackIdentifier)) {
                // The Spotify app is not installed, present the user with an App Store page
                //showAppStoreInstall()
            }
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Groups", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "groupsTVC") as! GroupsTableViewController
            nextViewController.dic = CoreFunc.retrieveDict()
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }

    }

}

extension AuthViewController: SPTAppRemotePlayerStateDelegate, SPTAppRemoteUserAPIDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
    }
    
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        
    }
}
