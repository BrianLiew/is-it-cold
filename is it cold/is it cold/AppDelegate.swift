//
//  AppDelegate.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let view_controller = ViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.is-it-cold.fetch", using: nil) { (task) in
            self.handle_background_refresh(task: task as! BGAppRefreshTask)
        } */
        return true
    }
    
    /*
    func handle_background_refresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            Networking.session.invalidateAndCancel()
        }
        view_controller.init_location_manager()
        
        task.setTaskCompleted(success: true)
        
        schedule_background_fetch()
    }
    
    func schedule_background_fetch() {
        let fetch_task = BGAppRefreshTaskRequest(identifier: "com.is-it.cold.fetch")
        fetch_task.earliestBeginDate = Date(timeIntervalSinceNow: 5)
        do {
            try BGTaskScheduler.shared.submit(fetch_task)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
     */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

extension Notification.Name {
    static let new_data_fetched = Notification.Name("com.is-it-cold.fetch")
}

