//
//  AppDelegate.swift
//  SPPlayer
//
//  Created by Eduardo Irias on 11/2/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    fileprivate let redirectUri = URL(string:"uwaves-ios://spotify-login-callback")!
    fileprivate let clientIdentifier = "b16114cc98a544668d2c2522f871006f"
    fileprivate let name = "UWAVES"

    static fileprivate let kAccessTokenKey = "https://uwaves.herokuapp.com/api/token"

    var window: UIWindow?
    
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: AppDelegate.kAccessTokenKey)
            defaults.synchronize()
        }
    }

    lazy var appRemote: SPTAppRemote = {
        let configuration = SPTConfiguration(clientID: self.clientIdentifier, redirectURL: self.redirectUri)
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appRemote.connect()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        appRemote.disconnect()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let parameters = appRemote.authorizationParameters(from: url);
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        }
        
        return true
    }
    
}

extension AppDelegate: SPTAppRemoteDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        NotificationCenter.default.post(name: NSNotification.Name.appRemoteDidEstablishConnection, object: appRemote)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        NotificationCenter.default.post(name: NSNotification.Name.didFailConnectionAttemptWithError, object: appRemote)
        print("didFailConnectionAttemptWithError")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
    }
}

extension NSNotification.Name {
    static let appRemoteDidEstablishConnection = Notification.Name("appRemoteDidEstablishConnection")
    static let didFailConnectionAttemptWithError = Notification.Name("didFailConnectionAttemptWithError")
}
