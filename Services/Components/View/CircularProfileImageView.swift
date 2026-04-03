//
//  CircularProfileImageView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import Kingfisher
import SwiftUI

enum ProfileImageSize {
    case xSmall
    case small
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
        case .xSmall:
            return 40
        case .small:
            return 48
        case .medium:
            return 64
        case .large:
            return 80
        }
    }
}

struct CircularProfileImageView: View {
//    let user: User
    let venue: Venue?
    let size: ProfileImageSize

    var body: some View {
        if let imageUrl = venue?.imageURLString {
            KFImage(URL(string: imageUrl))
                .resizable()
                .placeholder({ _ in
                    ProgressView()
                })
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .foregroundColor(Color(.systemGray4))
        }
    }
}

struct CircularUsersImageView: View {
    let post: Post?
    let size: ProfileImageSize

    var body: some View {
        if let imageUrl = post?.venue?.imageURLString {
            KFImage(URL(string: imageUrl))
                .resizable()
                .placeholder({ _ in
                    ProgressView()
                })
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .foregroundColor(Color(.systemGray4))
        }
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(venue: User.mockVenue[0], size: .large)
    }
}
