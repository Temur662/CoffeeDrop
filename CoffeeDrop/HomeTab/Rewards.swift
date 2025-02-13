//
//  Rewards.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/11/25.
//  Screen for User Rewards
// Origin : Home View

import SwiftUI

struct RewardsPointsBreakdown {
    let pointsNum : String
    let pointsDesc : String
}


struct Rewards: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userProfile: UserProfile // UserProfile Object
    var PointsBreakdown : [RewardsPointsBreakdown] = [
        RewardsPointsBreakdown(pointsNum : "50", pointsDesc : "Indulge in a flaky croissant or sweet muffin—it’s your treat!"),
        RewardsPointsBreakdown(pointsNum : "100", pointsDesc : "Savor one of our signature lattes, cappuccinos, or any specialty drink on the house."),
        RewardsPointsBreakdown(pointsNum : "200", pointsDesc : "Upgrade your midday break with a complimentary sandwich or light meal."),
        RewardsPointsBreakdown(pointsNum : "300", pointsDesc : "Enjoy $15 toward your next purchase."),
        RewardsPointsBreakdown(pointsNum : "450", pointsDesc : "Score our exclusive merch or grab $25 in store credit for your next coffee run."),
    ]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment: .leading, spacing: 10){
                Group{
                    Text("Rewards")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                    
                    RewardsHeaderCards()
                }
                .padding(.horizontal)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 400)
                    .background(Color(red: 1, green: 0.89, blue: 0.75).opacity(0.2))
                    .overlay(
                        ZStack(alignment: .leading){
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 348, height: 12)
                                .background(Color(red: 0.54, green: 0.32, blue: 0.16).opacity(0.4))
                                .cornerRadius(25)
                                .rotationEffect(Angle(degrees: 90))
                                .offset(x: (-348/2) )
                            VStack(alignment : .leading, spacing : 40){
                                ForEach(PointsBreakdown, id: \.self.pointsNum ){ points in
                                    HStack(spacing : 6){
                                        Group{
                                            Image(.coffeeBean)
                                                .resizable()
                                                .frame(width: 20, height : 20)
                                            Text("\(points.pointsNum)")
                                                .fontWeight(.bold)
                                                .font(.callout)
                                                .padding(.leading, 4)
                                        }
                                        Text("\(points.pointsDesc)")
                                            .font(.caption)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.top, points.pointsNum == "50" ? 30 : 0)
                                }
                            }
                            .frame(height : 348, alignment: .topLeading)
                            .padding(.horizontal, 10)
                        }
                    )
                
                Spacer()
                
                HStack{
                    Spacer()
                    Text("Bonus Rewards")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                
                VStack(alignment : .center){
                    HStack() {
                        
                        VStack{
                            Text("Birthday List")
                                .font(.caption)
                            Button(
                                action : {}
                            ){
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 70, height: 28)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.54, green: 0.32, blue: 0.16), lineWidth: 1)
                                            .overlay(
                                                Text("Join ")
                                                  .font(.system(size : 14))
                                                  .multilineTextAlignment(.center)
                                                  .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                            )
                                    )
                            }
                        }
                        
                        Spacer()
                        
                        Image(.birthdayCap)
                            .resizable()
                            .frame(width : 100, height: 100)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Celebrate in style—join our Birthday List and enjoy a sweet \nsurprise on your special day!")
                        .font(.system(size : 10))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                }
                
                VStack(alignment : .center){
                    HStack() {
                        
                        Image(.newsLetterIcon)
                            .resizable()
                            .frame(width : 120, height: 100)
                        
                        Spacer()
                        
                        VStack{
                            Text("Newsletter")
                                .font(.caption)
                            Button(
                                action : {}
                            ){
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 70, height: 28)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.54, green: 0.32, blue: 0.16), lineWidth: 1)
                                            .overlay(
                                                Text("Sign up ")
                                                    .font(.system(size : 14))
                                                  .multilineTextAlignment(.center)
                                                  .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                            )
                                    )
                            }
                        }
                                                
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Sign up for our newsletter to get fresh brews, special deals, and the latest buzz delivered straight to your inbox!")
                        .font(.system(size : 10))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                }
                .padding(.top)
                
                HStack{
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 123, height: 27)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(20)
                        .overlay(
                            Text("Terms & Conditions")
                                .font(.system(size : 10))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        )
                    Spacer()
                }
                .padding(.vertical, 20)
            }
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 25, height: 25)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .foregroundStyle(.black)
                                    .frame(width: 8, height: 8)
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                            )
                            .shadow(radius: 3, y : 3)
                    }
                }
            }
        }
    }
}

