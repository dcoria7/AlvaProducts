//
//  VenueDetailView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI

struct VenueDetailView: View {
    var venue: Venue
    
    var body: some View {
        VStack {
            Text(venue.title)
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .bold))
        }
    }
}

