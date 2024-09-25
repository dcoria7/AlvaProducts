//
//  ContentView.swift
//  MV-Project
//
//  Created by Daniel Coria on 01/08/23.
//

import SwiftUI

struct CatalogListScreen: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        List(store.products) { product in
            HStack {
                AsyncImage(
                    url: URL(string: product.image),
                    content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                }, placeholder:  {
                    ProgressView()
                        .frame(width: 100)
                })
                
                Text(product.title)
            }
            
        }.task {
            await populateProducts()
        }
    }
}

extension CatalogListScreen {
    private func populateProducts() async {
        do {
            try await store.loadProducts()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CatalogListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatalogListScreen()
    }
}
