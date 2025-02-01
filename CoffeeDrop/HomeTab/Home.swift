//
//  Home.swift
//  CoffeeDrop
//  Home Page of the App
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack{
            //  BackGround Linear Gradient
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 430, height: 166)
            .background(
            LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.54, green: 0.32, blue: 0.16), location: 0.00),
            Gradient.Stop(color: Color(red: 0.77, green: 0.66, blue: 0.58), location: 0.50),
            Gradient.Stop(color: .white, location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
            )
            )
            .cornerRadius(15)
            
            //  Profile Name , Notification Bell and Points Counter displayed in a Horizontal Stack on top of Gradient
            HStack{
                
                //  Profile Name
                HStack{
                    //  User Profile Pic
                    Circle()
                        .frame(width: 61, height: 61)
                    //  Welcome & User Name
                    VStack{
                        Text("Welcome,")
                        .font(
                        Font.custom("Poppins", size: 16)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        
                        Text("Emily Williams ")
                        .font(
                        Font.custom("Poppins", size: 14)
                        .weight(.light)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    }
                }
                .padding(.leading)
                
                Spacer()
                
                //  Notification Bell
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .overlay(
                            Image(.notificationBell)
                                .resizable()
                                .frame(width: 39, height: 39)
                        )
                        .frame(width: 51.8107, height: 51.81026, alignment: .center)
                }
                
                
                Spacer()
                
                // Points Counter
                ZStack{
                    //  BackGround Card
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 70, height: 48)
                        .background(.white)
                    
                        .cornerRadius(5)
                        .shadow(color: .white.opacity(0.5), radius: 2, x: 0, y: 0)
                    
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.54, green: 0.32, blue: 0.16).opacity(0.5), lineWidth: 1)
                        )
                    //  Points Display With CoffeeBean
                    VStack{
                        Spacer()
                        HStack{
                            Text("0")
                                .font(
                                    Font.custom("Poppins", size: 14)
                                        .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                            Image(.coffeeBean)
                        }
                        Spacer()
                    }
                    .frame(width: 70, height: 48)
                    
                    // Points Label (Overlaying Bottom)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black)
                        .frame(width: 50, height: 15)
                        .overlay(
                            Text("Points")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.white)
                        )
                        .offset(y: 25) // Moves it down to overlay the box
                }
                .frame(width: 70, height: 80)
                .padding(.trailing)
            }
        }
    }
}

