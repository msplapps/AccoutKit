//
//  ViewController.swift
//  AccoutKitLogin
//
//  Created by Harshvardhan Agarwal on 21/08/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import AccountKit


class ViewController: UIViewController {

    var _pendingLoginViewController: AKFViewController?
    var _authorizationCode: String?
    var isUserLoggedIn = false

    let ACCOUNT_KIT = AKFAccountKit(responseType: AKFResponseType.accessToken)
    
    @IBOutlet weak var statusLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _pendingLoginViewController = ACCOUNT_KIT.viewControllerForLoginResume() as? AKFViewController
        _pendingLoginViewController?.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        if (isUserLoggedIn) {
            //if the user is already logged in, go to the main screen
            //go to main screen
            print("User already logged in")
        } else if (_pendingLoginViewController != nil) {
            //resume pending login (if any)
            _pendingLoginViewController?.delegate = self

            self.present(_pendingLoginViewController as! UIViewController, animated: true, completion: nil)
            _pendingLoginViewController = nil;
        }
    }

 
    
    
    @IBAction func loginWithPhoneNumber(_ sender: Any) {
        
        
        if let accountKitPhoneLoginVC = ACCOUNT_KIT.viewControllerForPhoneLogin(with: nil, state: nil) as? AKFViewController{
            
            accountKitPhoneLoginVC.enableSendToFacebook = true
            
            accountKitPhoneLoginVC.delegate = self
            
            present(accountKitPhoneLoginVC as! UIViewController, animated: true, completion: nil)
            
        }
        
        
    }

    @IBAction func loginWithEmail(_ sender: Any) {
        
        if let accountKitEmailLoginVC = ACCOUNT_KIT.viewControllerForEmailLogin(withEmail: nil, state: nil) as? AKFViewController{
            
            accountKitEmailLoginVC.enableSendToFacebook = true
            
            accountKitEmailLoginVC.delegate = self
            
            present(accountKitEmailLoginVC as! UIViewController, animated: true, completion: nil)
            
        }
    }
  
}

//-------------------------------------------------------------------------

//MARK:- AKFViewControllerDelegate

//-------------------------------------------------------------------------

extension ViewController:AKFViewControllerDelegate{
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        
        print("didCompleteLoginWithAuthorizationCode")
        
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        ACCOUNT_KIT.requestAccount { (account:AKFAccount?, error:Error?) in
            
            if let phoneno = account?.phoneNumber?.stringRepresentation(){
                print(phoneno)
                self.statusLable.text = "Logged in with \(phoneno)"
            }
            
            if let emailAddress = account?.emailAddress{
                print(emailAddress)
                self.statusLable.text = "Logged in with \(emailAddress)"
            }
            
            if let accoutID = account?.accountID{
                print("accoutID:",accoutID)
            }
            
        }
        
        print("accessToken:",accessToken.tokenString)

        
    }
    
    
     func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        
        print("didFailWithError: \(error)")
        
    }
    
    
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        
        print("viewControllerDidCancel")
        
    }
    


}


