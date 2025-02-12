//
//  Map.swift
//  CoffeeDrop
//  Root View of the Map Tab
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI
import MapKit
struct MapTab: View {
    var animation: Namespace.ID
    var body: some View {
        NavigationStack{
            Map()
                .matchedGeometryEffect(id: "Map", in: animation)
                .navigationBarHidden(true) // Hide the Navigation Bar
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

