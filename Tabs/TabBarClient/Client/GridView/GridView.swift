//
//  GridView.swift
//  AlvaProducts
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI

struct GridVenue: View {
    var venue: Venue
    
    var body: some View {
        VStack {
            AsyncImage(
                url: URL(string: venue.imageURLString),
                content: { image in
                    
                    image
                        .resizable()
						.aspectRatio(contentMode: .fit)
						.frame(height: 140)
                        .clipped()
                        .overlay(venue.active ? .clear : Color.gray.opacity(0.8))
                }, placeholder:  {
                    ProgressView()
                        .frame(width: 100)
                })
        }
        .cornerRadius(10)
    }
}
