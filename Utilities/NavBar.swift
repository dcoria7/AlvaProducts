//
//  NavBar.swift
//  Marvel-swiftUI
//
//  Created by Daniel Coria on 09/04/21.
//

import UIKit
import SwiftUI

struct NavigationBarColor: ViewModifier {
	
	init(tintColor: UIColor) {
		let coloredAppearance = UINavigationBarAppearance()
		coloredAppearance.configureWithOpaqueBackground()
		coloredAppearance.backgroundColor = UIColor(_colorLiteralRed: 58/255, green: 58/255, blue: 60/255, alpha: 1)
		coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
		coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
		
		UINavigationBar.appearance().standardAppearance = coloredAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
		UINavigationBar.appearance().compactAppearance = coloredAppearance
		UINavigationBar.appearance().tintColor = tintColor
		
		let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
		tabBarAppearance.configureWithDefaultBackground()
		UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
	}
	
	func body(content: Content) -> some View {
		content
	}
}

extension View {
  func navigationBarColor(tintColor: UIColor) -> some View {
    self.modifier(NavigationBarColor(tintColor: tintColor))
  }
}

extension UINavigationBarAppearance {
    func setColor(title: UIColor? = nil, background: UIColor? = nil) {
        configureWithTransparentBackground()
        if let titleColor = title {
            largeTitleTextAttributes = [.foregroundColor: titleColor]
            titleTextAttributes = [.foregroundColor: titleColor]
        }
        backgroundColor = background
        UINavigationBar.appearance().scrollEdgeAppearance = self
        UINavigationBar.appearance().standardAppearance = self
    }
}
