//
//  _RewardsHeaderCard.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/11/25.
//

import SwiftUI

struct RewardsHeaderCards: View {
    var body: some View {
        Rectangle()
          .foregroundColor(.clear)
          .frame(height: 48)
          .frame(maxWidth: .infinity)
          .background(Color(red: 0.95, green: 0.95, blue: 0.95))
          .cornerRadius(10)
          .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
          .overlay(
            HStack(alignment: .center){
                Image(.coffeeBean)
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("Your Coffee, Your Points: Start Stacking Up Rewards Today!")
                    .font(.system(size: 11))
                    .fontWeight(.semibold)
                  .foregroundColor(.black)
            }
                .padding(.horizontal)
          )
    }
}
