//
//  GridView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI
import Kingfisher

struct GridVenue: View {
    var venue: Venue
    
    var body: some View {
        VStack {
			KFImage(URL(string: venue.imageURLString))
				.placeholder {
					ProgressView()
						.frame(width: 100)
				}
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 140)
				.clipped()
				.overlay(venue.active ? .clear : Color.gray.opacity(0.8))
                
        }
        .cornerRadius(10)
    }
}
