//
//  ClickLocal.swift
//  ClickLocal
//
//  Created by Daniel Coria on 03/04/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAppCheck
import JDStatusBarNotification

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		AppCheckManager.shared.setProviderFactory()
        FirebaseApp.configure()
		
		NotificationPresenter.shared.updateDefaultStyle { style in
			style.backgroundStyle.backgroundColor = .customBlack()
			style.textStyle.textColor = .customWite()
			style.textStyle.font = UIFont.preferredFont(forTextStyle: .title3)
			return style
		}
		NotificationPresenter.shared.displayActivityIndicator(true)
		
        return true
    }
}

@main
struct ClickLocal: App {
	
//	    @StateObject private var store = Store(storeHTTPClient: DefaultStoreHTTPClient())
	// register app delegate for Firebase setup
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	// StateObject to hold the AppCoordinator instance
	@StateObject var coordinator: AppCoordinator
	
	init() {
		
		// Initialize the AppCoordinator with required dependencies
		_coordinator = StateObject(
			wrappedValue: AppCoordinator())
	}
	
	var body: some Scene {
		WindowGroup {
			InitContentView(coordinator: coordinator)
			//                .environmentObject(store)
		}
	}
}
