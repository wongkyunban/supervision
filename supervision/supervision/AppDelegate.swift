//
//  AppDelegate.swift
//  supervision
//
//  Created by waterway on 2017/1/5.
//  Copyright © 2017年 waterway. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userData = UserData()
    var wvc:WelcomePageViewController?
    var navigationController:UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //判断是否第一次打开app
        let firstStarted = StorageUtils.getNormalDefault(keyName: "started") as? Bool
        if firstStarted == nil{
            self.wvc = WelcomePageViewController()
            self.navigationController = UINavigationController(rootViewController: self.wvc!)
            self.window?.rootViewController = self.navigationController
            wvc?.startClosure = {
                () -> Void in
                self.startApp()
            }
            StorageUtils.setNormalDefault(keyName: "started", keyValue: false as AnyObject)
        }else{
            self.startApp()
        }
        self.window?.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.transform(fromHexString: "#1b7dc9")
        self.window?.makeKeyAndVisible()
        self.window?.addSubview((self.navigationController?.view)!)
        return true
    }
    
    func startApp(){
        if self.wvc != nil {
            self.wvc = nil
        }
        self.navigationController = UINavigationController(rootViewController: LoginViewController())
        self.window?.rootViewController = self.navigationController
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

