//
//  AuthHome.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//  Home Root View of Auth Screens Stack
import SwiftUI
import Supabase

struct AuthView: View {
    @State var progress : CGFloat = 0
    @State var CurrentCard : Int = 0
    @State var NextCard : Int = 0
    @State var CurrentIndicatorWidth : CGFloat = 0
    @State var NextIndicatorWidth : CGFloat = 0
    @State var InterpolatedOpacityValue : CGFloat = 1
    @State var NextInterpolatedOpacityValue : CGFloat = 0.2
    var body : some View {
        GeometryReader{ geometry in
            VStack{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(0..<3){ i in
                            //  CoffeeDrop Header
                            VStack(spacing: 0){
                                //  Header BackGround
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: geometry.size.width, height: 100)
                                    .background(Color(red: 0.56, green: 0.85, blue: 0.98))
                                    .overlay(
                                        //  CoffeeDrop Text
                                        VStack{
                                            Text("COFFEE")
                                                .font(
                                                    Font.custom("Poppins", size: 36)
                                                )
                                                .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                                .bold()
                                            Text("DROP")
                                                .font(
                                                    Font.custom("Poppins", size: 36)
                                                )
                                                .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                                .bold()
                                        }
                                    )
                                //  End of Header
                                
                                //  CoffeeDrop Icon
                                    Rectangle()
                                        .foregroundStyle(Color.clear)
                                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                        .overlay(
                                            Image(.coffeeDropIcon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: geometry.size.width, height: geometry.size.height * 0.39)
                                        )
                                        .background(Color(red: 0.56, green: 0.85, blue: 0.98))
                                        .padding(.top)

                                //  Text
                                Text("Experience \n Cafés ")
                                    .font(Font.custom("Poppins", size: 28))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.09, green: 0.11, blue: 0.18))
                                    .frame(width: 239, alignment: .top)
                                    .padding(.top, 35)
                                
                                Text("Without feeling limited")
                                    .font(Font.custom("Poppins", size: 18))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                                    .frame(width: 256, alignment: .top)
                                    .padding(.top)
                            }
                            //  End of Cards
                            .background(
                                //  Pagination BackGroundTask
                                GeometryReader{ geo -> Color in
                                    DispatchQueue.main.async {
                                        let scrollViewWidth = geo.size.width //    Width of each card
                                        let minX = geo.frame(in: .global).minX //  Direction Card is being scrolled
                                        let progress = abs(minX / scrollViewWidth) //    Progress Tracker
                                        let currentCard = Int(progress)
                                        let nextCard = Int(progress + 1)
                                        
                                        let indicatorProgress = progress - CGFloat(currentCard)
                                        
                                        let currentIndicatorWidth = 28 - (28 * indicatorProgress)
                                        
                                        let nextIndicatorWidth = 28 * indicatorProgress
                                        
                                        let interpolatedOpacityValue = interpolate(value: currentIndicatorWidth, from: 0...28, to: 0.2...1)
                                        let nextInterpolatedOpacityValue = interpolate(value: nextIndicatorWidth, from: 0...28, to: 0.2...1)
                                        self.progress = progress
                                        self.CurrentCard = currentCard
                                        self.NextCard = nextCard
                                        self.CurrentIndicatorWidth = currentIndicatorWidth
                                        self.NextIndicatorWidth = nextIndicatorWidth
                                        
                                        self.InterpolatedOpacityValue = interpolatedOpacityValue
                                        
                                        self.NextInterpolatedOpacityValue = nextInterpolatedOpacityValue
                                    }
                                    return Color.clear
                                }
                            )
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollBounceBehavior(.basedOnSize)
                //  Paginator for scrolling Cards
                Spacer()
                HStack{
                    ForEach(0..<3){ index in
                        
                        Capsule()
                            .foregroundStyle(index == CurrentCard ? Color(red: 0.2, green: 0.29, blue: 0.35).opacity(InterpolatedOpacityValue) : index == NextCard ? Color(red: 0.2, green: 0.29, blue: 0.35).opacity(NextInterpolatedOpacityValue) : Color(red: 0.2, green: 0.29, blue: 0.35).opacity(0.2))
                            .frame(width: index == CurrentCard ? CurrentIndicatorWidth + 10 : index == NextCard ? 10 + NextIndicatorWidth  : 10, height: 10)
                    }
                }
                Spacer()
                HStack{
                    Spacer()
                    Spacer()
                    NavigationLink(destination: LoginView()){
                        ZStack {
                            Circle()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(Color(red: 0.54, green: 0.32, blue: 0.16))
                            Image(systemName: "arrow.right")
                                .font(Font.title.weight(.semibold))
                                .foregroundStyle(Color.white)
                                .frame(width: 40, height: 40)
                        }
                        .padding(.trailing, 35)
                    }
                }
            }
        }
    }
    // A helper function for interpolation
    func interpolate(value: CGFloat, from inputRange: ClosedRange<CGFloat>, to outputRange: ClosedRange<CGFloat>) -> CGFloat {
        let inputMin = inputRange.lowerBound
        let inputMax = inputRange.upperBound
        let outputMin = outputRange.lowerBound
        let outputMax = outputRange.upperBound
        
        // Calculate the normalized value in the input range (0 to 1)
        let normalizedValue = (value - inputMin) / (inputMax - inputMin)
        
        // Map the normalized value to the output range
        return CGFloat(outputMin + normalizedValue * (outputMax - outputMin))
    }
}

