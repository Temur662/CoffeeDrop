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

struct StackedCardsView: View {
    var  cards : [CardInfo] = [
        CardInfo(card_title: "Chase", card_color: Color(red: 0.02, green: 0.4, blue: 0.68)),
        CardInfo(card_title: "CoffeeDrop", card_color: Color(red: 0.86, green: 0.92, blue: 0.95)),
        CardInfo(card_title: "CoffeeDrop", card_color: Color(red: 0.56, green: 0.85, blue: 0.98)),

    ]
    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id :\.0) { index, card in
                CardView(cardTitle: card.card_title, card_color: card.card_color)
                    .rotation3DEffect(
                        .degrees(-15),  //  Constant
                        axis: (x: 1, y: 0, z: 0),   // Constant
                        perspective: 0.7 // Constant
                    )
                    .offset(y: 80 * CGFloat(index))  //
                    .zIndex(CGFloat(index + 1))
            }
        }
        .padding()
    }
}

// Example of a card-like subview
struct CardView: View {
    let cardTitle: String
    let card_color : Color
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(card_color)
            .frame(width: 343.5, height: 199)
            .overlay(alignment : .topLeading){
                Text(cardTitle)
                    .font(.title)
                    .foregroundColor(.brown)
            }
            .shadow(radius: 5)
    }
}

