//
//  _CoffeeDropCard.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/6/25.
//  CoffeeDrop Card

import SwiftUI

struct CoffeeDropCard : View {
    @Binding var GoToRewards : Bool
    var body : some View {
        GeometryReader{ geo in
            VStack(alignment : .center){
                Image(.coffeeDropCard)
                    .resizable()
                    .blur(radius: 5)
                    .overlay(
                        Rectangle()
                        .foregroundColor(.clear)
                        .background(
                        LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.5), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.55, green: 0.55, blue: 0.55).opacity(0.2), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                        )
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 20)
                        .overlay(
                            VStack{
                                HStack{
                                    Text("Balance")
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                    Spacer()
                                    Spacer()
                                }
                                HStack{
                                    Text("XX Points")
                                        .foregroundStyle(Color.white)

                                    Spacer()
                                    Text("$X.XX")
                                        .foregroundStyle(Color.white)

                                }
                                .padding(.vertical, 4)
                                    .background(
                                        VStack {
                                            Spacer()
                                            Color(Color.white)
                                                .frame(height: 1)
                                        }
                                )
                                
                                HStack{
                                    Spacer()
                                    Spacer()
                                    Text("$1 = 1 point")
                                        .foregroundStyle(Color.white)
                                }
                                
                                //  CoffeeDrop Progress Bar
                                
                                CoffeeDropPointsProgressBar()
                                
                                
                                //  Rewards Button Link
                                HStack{
                                    NavigationLink(destination: Rewards()){
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 85, height: 30)
                                            .background(Color(red: 0.62, green: 0.49, blue: 0.32))
                                            .cornerRadius(30)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .inset(by: 0.5)
                                                    .stroke(.white, lineWidth: 1)
                                                    .overlay(
                                                        Text("Rewards")
                                                            .foregroundStyle(Color.white)
                                                    )
                                            )
                                    }
                                    Spacer()
                                    Spacer()
                                }
                                .padding(.top, 8)

                            }
                            .padding()
                        )
                    )
            }
        }
    }
}
