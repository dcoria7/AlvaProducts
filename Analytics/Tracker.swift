//
//  Tracker.swift
//  AlvaProducts
//
//  Created by DC on 14/10/24.
//

import Foundation
import FirebaseAnalytics

final class Tracker {
	static func trackFeedEvent() {
		Analytics.logEvent("FeedViewEvent",
						   parameters: nil)
		
		Analytics.logEvent(AnalyticsEventScreenView,
						   parameters: [
							AnalyticsParameterScreenName: "Screen-\(FeedView.self)",
							AnalyticsParameterScreenClass: "Class-\(FeedView.self)"
						   ])
	}
	
	static func trackVenuesEvent() {
		Analytics.logEvent("VenuesViewEvent",
						   parameters: nil)
		
		Analytics.logEvent(AnalyticsEventScreenView,
						   parameters: [
							AnalyticsParameterScreenName: "Screen-\(VenuesView.self)",
							AnalyticsParameterScreenClass: "Class-\(VenuesView.self)"
						   ])
	}
	
	static func trackVenueDetailEvent(id: String, name: String) {
		Analytics.logEvent("VenueDetailViewEvent",
						   parameters: ["userId": id, "name": name])
		
		Analytics.logEvent(AnalyticsEventScreenView,
						   parameters: [
							AnalyticsParameterScreenName: "Screen-\(VenueDetailView.self)",
							AnalyticsParameterScreenClass: "Class-\(VenueDetailView.self)",
							AnalyticsParameterItemID: "id-\(id)",
							AnalyticsParameterItemName: name,
							AnalyticsParameterContentType: "content",
						   ])
	}
	
	static func trackProfileEvent(id: String, name: String) {
		Analytics.logEvent("ProfileViewEvent",
						   parameters: ["userId": id, "name": name])
		
		Analytics.logEvent(AnalyticsEventScreenView,
						   parameters: [
							AnalyticsParameterScreenName: "Screen-\(ProfileView.self)",
							AnalyticsParameterScreenClass: "Class-\(ProfileView.self)",
							AnalyticsParameterItemID: "id-\(id)",
							AnalyticsParameterItemName: name,
							AnalyticsParameterContentType: "content",
						   ])
	}
	
	
}
