//
//  ActivityIndicator.swift
//  Marvel-swiftUI
//
//  Created by Daniel Coria on 09/04/21.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var animate: Bool
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
