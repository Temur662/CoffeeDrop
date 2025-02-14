//
//  Wallet.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/11/25.
//  Root View of Wallet Tab

import SwiftUI

struct Wallet : View {
    @EnvironmentObject var userProfile : UserProfile
    @State var DetailViewIsPresented : Bool = false
    @Namespace var CardAnimation
    @State private var cards : [CardInfo] = [
        CardInfo(card_title: "Chase", card_color: Color(red: 0.02, green: 0.4, blue: 0.68)),
        CardInfo(card_title: "CoffeeDrop", card_color: Color(red: 0.86, green: 0.92, blue: 0.95)),
        CardInfo(card_title: "CoffeeDrop1", card_color: Color(red: 0.56, green: 0.85, blue: 0.98)),
    ]
    @State private var selectedCard : CardInfo?
    //  @State private var cardOffSets: [CGSize] = Array(repeating: CGSize.zero, count: 5)
    //  @State private var cardRotation: Double = 0.0
    //  @State private var currentCardIndex: Int = 0
    //  @State private var cardScale: CGFloat = 1.0
    //  @GestureState private var dragOffset = CGSize.zero
    @State private var CurrentCard : Int = 0
    @State private var NextCard : Int = 0
    @State private var CurrentIndicatorWidth : CGFloat = 0
    @State var NextIndicatorWidth : CGFloat = 0
    @State var InterpolatedOpacityValue : CGFloat = 1
    @State var NextInterpolatedOpacityValue : CGFloat = 0.2
    var AddFundsButtons = [
        "20", "25", "30"
    ]
    var body : some View {
        ZStack{
            
            Color(red: 0.96, green: 0.96, blue: 0.96)
            
            VStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 430, height: 371)
                    .background(Color(red: 0.88, green: 0.9, blue: 0.93))
                    .overlay(alignment: .top){
                        VStack(alignment : .leading){
                            if DetailViewIsPresented {
                                Button( action : {
                                    withAnimation {
                                        DetailViewIsPresented.toggle()
                                    }} ){
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
                            HStack{
                                Text("Wallet")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                                Circle()
                                    .fill(Color(red: 0.56, green: 0.85, blue: 0.98))
                                    .frame(width: 25, height: 25)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .resizable()
                                            .foregroundStyle(.white)
                                            .frame(width: 8, height: 8)
                                            .aspectRatio(contentMode: .fit)
                                            .padding()
                                    )
                                    .shadow(radius: 3, y : 3)
                            }
                        }
                        .padding(.top, 80)
                        .padding(.horizontal, 30)
                    }
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                if DetailViewIsPresented {
                    GeometryReader{ geo in
                        VStack(alignment: .center, spacing: 20){
                            HStack{
                                ForEach(Array(cards.enumerated()), id :\.0) { index, card in
                                    Capsule()
                                        .foregroundStyle(index == CurrentCard ? Color(red: 0.77, green: 0.77, blue: 0.77).opacity(InterpolatedOpacityValue) : index == NextCard ? Color(red: 0.77, green: 0.77, blue: 0.77).opacity(NextInterpolatedOpacityValue) : Color(red: 0.77, green: 0.77, blue: 0.77).opacity(0.2))
                                    
                                        .frame(width: index == CurrentCard ? CurrentIndicatorWidth + 10 : index == NextCard ? 10 + NextIndicatorWidth  : 10, height: 10)
                                }
                            }
                            ScrollView(.horizontal, showsIndicators: false){
                                let width = geo.size.width
                                HStack{
                                    ForEach(Array(cards.enumerated()), id :\.0) { index, card in
                                        VStack{
                                            ZStack(alignment: .topTrailing){
                                                CardView(card : card)
                                                    .frame(width : width)
                                                    .offset(y : 0)
                                                    .matchedGeometryEffect(id: card.card_id, in: CardAnimation)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            DetailViewIsPresented.toggle()
                                                        }
                                                    }
                                                    Rectangle()
                                                      .foregroundColor(.clear)
                                                      .frame(width: 50, height: 20)
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
                                                        RoundedRectangle(cornerRadius: 15)
                                                          .inset(by: 0.5)
                                                          .stroke(.white.opacity(0.6), lineWidth: 1)
                                                      )
                                                      .blur(radius: 10)
                                            }
                                            
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 398, height: 229)
                                                .background(.white)
                                                .cornerRadius(15)
                                                .offset(y : -40)
                                                .zIndex(1)
                                                .overlay(
                                                    VStack{
                                                        HStack{
                                                            Text("Current Balance ")
                                                                .font(.headline)
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                                                            
                                                            Text("$XX.XX")
                                                                .font(.title)
                                                                .fontWeight(.bold)
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(.black)
                                                                .frame(width: 121, height: 21, alignment: .center)
                                                        }
                                                        HStack{
                                                            Text("Add Funds")
                                                                .font(.headline)
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                                                            Spacer()
                                                            Spacer()
                                                        }
                                                        VStack{
                                                            
                                                            HStack{
                                                                ForEach(AddFundsButtons, id : \.self){ fund in
                                                                    Rectangle()
                                                                        .foregroundColor(.clear)
                                                                        .frame(width: 94, height: 33)
                                                                        .background(.white)
                                                                        .cornerRadius(10)
                                                                        .overlay(
                                                                            RoundedRectangle(cornerRadius: 10)
                                                                                .inset(by: 0.5)
                                                                                .stroke(Color(red: 0.54, green: 0.32, blue: 0.16).opacity(0.5), lineWidth: 1)
                                                                                .overlay(
                                                                                    Text("$\(fund)")
                                                                                        .multilineTextAlignment(.center)
                                                                                        .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                                                                )
                                                                        )
                                                                }
                                                            }
                                                            
                                                            Rectangle()
                                                                .foregroundColor(.clear)
                                                                .frame(width: 144, height: 48)
                                                                .background(.white)
                                                                .cornerRadius(10)
                                                                .overlay(
                                                                    RoundedRectangle(cornerRadius: 10)
                                                                        .inset(by: 0.5)
                                                                        .stroke(Color(red: 0.54, green: 0.32, blue: 0.16).opacity(0.5), lineWidth: 1)
                                                                        .overlay(
                                                                            Text("+\n Other Amount")
                                                                                .multilineTextAlignment(.center)
                                                                                .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                                                        )
                                                                )
                                                            
                                                            Rectangle()
                                                                .foregroundColor(.clear)
                                                                .frame(width: 398, height: 73)
                                                                .background(.white)
                                                                .cornerRadius(15)
                                                                .overlay(
                                                                    HStack{
                                                                        
                                                                    }
                                                                )
                                                            
                                                        }
                                                    }
                                                )
                                                .padding(.horizontal)
                                        }
                                        .background(
                                            //  Pagination BackGroundTask
                                            GeometryReader{ geo -> Color in
                                                DispatchQueue.main.async {
                                                    let scrollViewWidth = geo.size.width //    Width of each card
                                                    let minX = geo.frame(in: .global).minX //  Direction Card is being scrolled
                                                    let progress = abs(minX / scrollViewWidth) //    Progress Tracker
                                                    //  Potential Crashs cause of this line ( Look into it )
                                                    let currentCard = Int(progress)
                                                    let nextCard = Int(progress + 1)
                                                    
                                                    let indicatorProgress = progress - CGFloat(currentCard)
                                                    
                                                    let currentIndicatorWidth = 28 - (28 * indicatorProgress)
                                                    
                                                    let nextIndicatorWidth = 28 * indicatorProgress
                                                    
                                                    let interpolatedOpacityValue = interpolate(value: currentIndicatorWidth, from: 0...28, to: 0.2...1)
                                                    let nextInterpolatedOpacityValue = interpolate(value: nextIndicatorWidth, from: 0...28, to: 0.2...1)
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
                                        .padding(.top, 10)
                                        
                                        //  End of Cards
                                        
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .scrollBounceBehavior(.basedOnSize)
                        }
                        .padding(.top, 120)
                    }
                } else {
                        ZStack {
                            ForEach(Array(cards.enumerated()), id :\.0) { index, card in
                                CardView(card : card)
                                    .rotation3DEffect(
                                        .degrees(-15),  //  Constant
                                        axis: (x: 1, y: 0, z: 0),   // Constant
                                        perspective: 0.7 // Constant
                                    )
                                    .offset(y : 80 * CGFloat(index))
                                    .zIndex(CGFloat(index + 1))
                                    .matchedGeometryEffect(id: card.card_id , in: CardAnimation)
                                    .onTapGesture {
                                        selectedCard = card
                                        cards.swapAt(0, index)
                                        withAnimation {
                                            DetailViewIsPresented.toggle()
                                        }
                                    }
                            }
                        }
                        .offset(x : 70)
                        .padding(.top, 100)
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action : {}){
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 116, height: 46)
                                    .background(Color(red: 0.56, green: 0.85, blue: 0.98))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                    .overlay(
                                        Text("Add Funds ")
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .padding([.horizontal,.bottom], 30)
                        
                    }
                }
                
            }
            // .navigationBarHidden(true) // Hide the Navigation Bar
            // .edgesIgnoringSafeArea(.vertical) // Extend content to top safe area
        }
    func GetUsersCards(){
        /*
         Get all cards associated with User_ID
         */
    }
    
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
    

