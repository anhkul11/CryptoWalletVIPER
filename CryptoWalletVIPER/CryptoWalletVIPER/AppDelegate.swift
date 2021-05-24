//
//  AppDelegate.swift
//  CryptoWalletVIPER
//
//  Created by Anh Lê on 5/24/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIApplication.shared.windows.first
    window?.becomeKey()
    
    return true
  }

}

