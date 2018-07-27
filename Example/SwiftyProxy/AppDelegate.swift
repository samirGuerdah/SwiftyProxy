//
//  AppDelegate.swift
//  SwiftyProxy
//
//  Created by Samir Guerdah on 07/20/2018.
//  Copyright (c) 2018 Samir Guerdah. All rights reserved.
//

import UIKit

import SwiftyProxy

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SwiftyProxy.enable()
        return true
    }
}

