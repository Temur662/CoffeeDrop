//
//  CardDetails.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/12/25.
//

import SwiftUI

struct CardDetails : View {
    @State var card : CardInfo
    @Namespace private var CardAnimation

    var body : some View {
        ScrollView{
            
            VStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(card.card_color)
                    .frame(width: 500, height: 199)
                    .overlay(alignment : .topLeading){
                        Text(card.card_title)
                            .font(.title)
                            .foregroundColor(.brown)
                    }
                    .shadow(radius: 5)
                    .navigationTransition(.zoom(sourceID:card.card_id, in: CardAnimation))
            }
            
        }
    }
}
