//
//  VenuesView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct VenuesView: View {
    @FirestoreQuery(collectionPath: "venues") var venues: [Venue]
//    @Environment(\.colorScheme) var colorScheme
    
    var vGridLayout = [
        GridItem(.adaptive(minimum: 170))
    ]
	
	private let fixedColumns = [
		GridItem(.fixed(170)),
		GridItem(.fixed(170))
	]
    
    var body: some View {
		NavigationStack {
            ZStack {
                ScrollView(.vertical) {
					LazyVGrid(columns: fixedColumns, spacing: 20) {
                        Section("Abiertos") {
                            if $venues.error != nil {
                                Text("There was an error: ")
                            }
                            ForEach(venues) { venue in
                                if venue.available && venue.active {
									NavigationLink(value: venue) {
                                        GridVenue(venue: venue)
											.frame(alignment: .center)
                                    }
                                }
                            }
                        }
                        .foregroundColor(.green)
                        .font(.title)
						.fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Section("Cerrados") {
                            if $venues.error != nil {
                                Text("There was an error: ")
                            }
                            ForEach(venues) { venue in
                                if venue.available && !venue.active {
									NavigationLink(value: venue) {
                                        GridVenue(venue: venue)
                                    }
                                }
                            }
                        }
						.foregroundColor(.gray)
                        .font(.title)
						.fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal, 10)
			.setDefaultBackgroundColor()
            .navigationTitle(Text("Tiendas"))
			.navigationDestination(for: Venue.self) { venue in
				VenueDetailView(userId: venue.userId ?? "", venue: venue)
			}
			.onAppear {
				Tracker.trackVenuesEvent()
			}
        }
    }
}

#Preview {
    VenuesView()
}
