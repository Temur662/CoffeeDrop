//
//  _CoffeeDropPointsProgressBar.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/7/25.
//  Progress points tracker

import SwiftUI

struct CoffeeDropPointsProgressBar: View {
    @State var userPoints : CGFloat = 300
    var pointsProgress : CGFloat {
        return userPoints / 500
    }
    @State private var progress : CGFloat = 1
    var width : CGFloat = 300
    var body : some View {
        ZStack(alignment : .leading){
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width, height: 5)
                .foregroundStyle(Color.white)
            
            HStack(spacing: 40){
                ForEach(0..<5){ item in
                    if userPoints >= CGFloat(item + 1) * 100 {
                        Circle()
                            .fill(Color(red: 0.54, green: 0.32, blue: 0.16))
                            .frame(width: 16, height: 16)
                    }
                    else{
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .opacity(0.7)
                    }
                }
            }
            .offset(x: 60)
            
            HStack(spacing: -5){
                Rectangle()
                    .frame(width: progress, height: 5)
                    .background(Color(red: 0.54, green: 0.32, blue: 0.16))
                    .foregroundStyle(.clear)
                    .cornerRadius(10)
                Image(.coffeeDropIcon)
                    .resizable()
                    .frame(width : 16, height : 16)
                    .clipShape(Circle())

            }
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 1.5)){
                progress = (width * pointsProgress) - 6
            }
        }
    }
}



