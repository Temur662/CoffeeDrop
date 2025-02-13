//
//  _WalletCard.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/12/25.
//  Card Components for Wallet tab

import SwiftUI

struct WalletCard : View {
    var body : some View{
        Rectangle()
            .frame(width: 351.5, height: 199)
            .background(Color(red: 0.02, green: 0.4, blue: 0.68))
            .foregroundStyle(.clear)
            .shadow(color: Color(red: 0.56, green: 0.85, blue: 0.98).opacity(0.3), radius: 2, x: 0, y: 4)
            .rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))
    }
}
    
struct CardInfo {
    let card_id : UUID = UUID()
    let card_title : String
    let card_color : Color
}
// Example of a card-like subview
struct CardView: View {
    @Namespace private var CardAnimation
    let card : CardInfo
    var body: some View {
        
            RoundedRectangle(cornerRadius: 12)
                .fill(card.card_color)
                .frame(width: 343.5, height: 199)
                .overlay(alignment : .topLeading){
                    Text(card.card_title)
                        .font(.title)
                        .foregroundColor(.brown)
                        .padding()
                }
                .shadow(radius: 5)
    }
}

