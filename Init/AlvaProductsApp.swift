//
//  AlvaProductsApp.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 03/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        return true
    }
}

@main
struct AlvaProductsApp: App {
    
    @StateObject private var store = Store(storeHTTPClient: DefaultStoreHTTPClient())
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            MainView()
            InitContentView()
                .environmentObject(store)
        }
    }
}
