//
//  ShareViewController.swift
//  SPPlayerShare
//
//  Created by Ethan Chen on 11/17/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {

    var testArr = ["Abby", "Bob", "Catherine", "David", "Ethan", "Frank", "Gordon", "Harry"]
    var nameSet = Set<String>()
    var url = ""
    @IBOutlet weak var shareViewPopup: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var shareTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var textFireldViewBotton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndSetContentFromContext()
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        textFireldViewBotton.constant = -90
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareViewPopup.fadeIn()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shareViewPopup.fadeOut()
    }

    @IBAction func sendAction(_ sender: Any) {
        //MARK: share song action and complete extension action
        if let text = self.shareTextField.text {
            for name in Array(nameSet) {
                CoreFunc.saveIDToGroup(name, CoreFunc.retriveIdFromUrl(self.url), text)
            }
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }

    }
    @IBAction func dismiss(_ sender: Any) {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        bottom.constant = keyboardHeight
        
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        bottom.constant = 8
    }
    private func fetchAndSetContentFromContext() {
        
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = kUTTypeURL as String
        if let attachments = extensionItem.attachments {
            for attachment in attachments{
                
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                    
                    guard let url = results as? URL else {
                        print("eror")
                        return
                    }
                    OperationQueue.main.addOperation {
                        self.url = url.absoluteString
                        print(url.absoluteString)
                    }
                    
                })
                
                
            }
        }

    }

}
extension ShareViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareContactCell", for: indexPath) as! ShareGroupCollectionViewCell
        cell.nameLbl.text = testArr[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareContactCell", for: indexPath) as! ShareGroupCollectionViewCell
        if cell.isSelected {
            nameSet.insert(testArr[indexPath.row])
            if nameSet.count > 0 {
                textFireldViewBotton.constant = 0
            }
            else{
                textFireldViewBotton.constant = -90
            }
        }
        print(nameSet)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareContactCell", for: indexPath) as! ShareGroupCollectionViewCell
        if !cell.isSelected {
            nameSet.remove(testArr[indexPath.row])
            if nameSet.count > 0 {
                textFireldViewBotton.constant = 0
            }
            else{
                textFireldViewBotton.constant = -90
            }
        }
        print(nameSet)
    }
    
    
}

extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
