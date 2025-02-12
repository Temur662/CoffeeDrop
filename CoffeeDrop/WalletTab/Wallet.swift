//
//  Wallet.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/11/25.
//  Root View of Wallet Tab

import SwiftUI

struct Wallet : View {
    @EnvironmentObject var userProfile : UserProfile
    var body : some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                ZStack{
                        VStack{
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 430, height: 371, alignment: .top)
                              .background(Color(red: 0.88, green: 0.9, blue: 0.93))
                              .overlay(alignment : .top){
                                  HStack{
                                      Text("Wallet")
                                          .font(Font.custom("Poppins", size: 36))
                                          .multilineTextAlignment(.center)
                                          .foregroundColor(.black)
                                          .frame(height: 46, alignment: .center)
                                      Spacer()
                                      Text("\(Image(systemName : "plus"))")
                                          .overlay(
                                            Circle()
                                                .fill(Color(red: 0.56, green: 0.85, blue: 0.98))
                                                .frame(width: 35, height: 35)
                                          )
                                  }
                                  .padding([.top, .horizontal], 50)
                              }
                            Spacer()
                        }
                    
                    VStack{
                        
                        StackedCardsView()
                        Spacer()
                        HStack{
                            Spacer()
                            Spacer()
                            Button(
                                action : {}
                            ){
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 116, height: 46)
                                    .background(Color(red: 0.56, green: 0.85, blue: 0.98))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                    .overlay(
                                        Text("Add Funds ")
                                            .font(
                                                Font.custom("Poppins", size: 16)
                                                    .weight(.semibold)
                                            )
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 100)
                    
                }
            }
            .navigationBarHidden(true) // Hide the Navigation Bar
            .edgesIgnoringSafeArea(.vertical) // Extend content to top safe area
        }
    }
}

