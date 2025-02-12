//
//  _QuickOrderCard.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/11/25.
//

import SwiftUI

struct QuickOrderCard : View {
    var body: some View {
        Rectangle()
          .foregroundColor(.clear)
          .frame(height: 48)
          .frame(maxWidth: .infinity)
          .background(Color(red: 0.95, green: 0.95, blue: 0.95))
          .cornerRadius(10)
          .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
          .overlay(
            HStack{
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 26, height: 26)
                  .background(Color(red: 0.82, green: 0.73, blue: 0.66).opacity(0.7))
                  .cornerRadius(5)
                  .overlay(
                    Image(.coffeeCupIcon)
                        .resizable()
                        .padding()
                        .frame(width: 18, height: 18)
                  )
                VStack(alignment: .leading, spacing : 2){
                    Text("Quick Order ")
                        .font(.caption)
                        .fontWeight(.semibold)
                      .foregroundColor(.black)
                    Text("Never Forget Your Last Order ")
                        .font(.system(size: 8))
                      .foregroundColor(Color(red: 0.27, green: 0.17, blue: 0.11).opacity(0.5))
                }
                
                Spacer()
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 47, height: 20)
                  .background(Color(red: 0.56, green: 0.85, blue: 0.98).opacity(0.3))
                  .cornerRadius(25)
                  .overlay(
                        Text("ORDER")
                            .fontWeight(.semibold)
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 0, green: 0.35, blue: 0.51))
                            
                  )
                
            }
                .padding(.horizontal)
          )
    }
}
