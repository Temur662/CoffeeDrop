//
//  Home.swift
//  CoffeeDrop
//  Home Page of the App
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI
import MapKit

struct Home: View {
    @EnvironmentObject var userProfile: UserProfile // UserProfile Object
    @StateObject private var locationManagerModel = ContentViewModel()
    @State private var searchText: String = ""
    @State private var hasCancel: Bool = true
    @State private var mainHeaderOpacity: CGFloat = 0
    @State private var subHeaderOpacity: CGFloat = 0
    @State private var headerHeight : CGFloat = 0
    var body: some View {
            ScrollView(.vertical, showsIndicators: false){
                
                 ZStack{
                     //  Cafe Searchbar
                     VStack(spacing: 20){
                         Rectangle()
                             .foregroundColor(.clear)
                             .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.97, green: 0.95, blue: 0.94), location: 0.41),
                                        Gradient.Stop(color: Color(red: 0.56, green: 0.85, blue: 0.98), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0.5),
                                    endPoint: UnitPoint(x: 1, y: 0.5)
                                )
                             )
                             .cornerRadius(20)
                             .overlay(
                                HStack{
                                    //  SearchBar
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 270, height: 47)
                                        .background(.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .inset(by: 0.5)
                                                .stroke(Color(red: 0.56, green: 0.85, blue: 0.98), lineWidth: 1)
                                        )
                                        .zIndex(1)
                                    //  Map
                                    Map(position : $locationManagerModel.cameraPosition )
                                    {
                                        UserAnnotation()
                                    }
                                    .clipShape(.rect(
                                        topLeadingRadius: 20,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 20,
                                        topTrailingRadius: 20
                                    ))
                                    .frame(width: 100)
                                    .offset(x: -25)
                                    .mapStyle(.standard(elevation : .realistic))
                                    .onAppear {
                                        locationManagerModel.checkIfLocationServicesEnabled()
                                    }
                                    .onChange(of: locationManagerModel.cameraPosition) { oldState, value in
                                        userProfile.userLocation = value
                                    }
                                    
                                    
                                }
                             )
                             .frame( height: 49)
                             .padding(.top, 10)
                         //  End of Cafe Searchbar
                         
                         //  CoffeeDrop Card
                         CoffeeDropCard()
                             .frame( height: 200, alignment: .center)
                         //  End of CoffeDrop Card
                         
                         //  Cafes Near Me
                         HStack{
                             Text("Cafés Near You ")
                                 .multilineTextAlignment(.center)
                                 .foregroundColor(.black)
                                 .font(.headline)
                                 .frame(alignment: .leading)
                                 .padding([.top, .leading])
                             Spacer()
                             Spacer()
                         }
                         
                         CafesNearMeView()
                             .padding([.leading, .trailing])
                         
                         
                         
                         Button(
                            action: {
                                SignOutUser()
                            }
                         ) {
                             Label("Logout", systemImage: "xmark")
                         }
                         GeometryReader{ geo in
                             
                         }
                         .padding(.bottom,800)
                         
                     }
                     .padding(.horizontal, 20)

                     .padding(.top, 200)
                     
                     // Top Layer (Header)
                    GeometryReader { gr in
                        VStack {
                            //  Background Linear Gradient
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.83, green: 0.72, blue: 0.58), location: 0.00),
                                            Gradient.Stop(color: .white, location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0),
                                        endPoint: UnitPoint(x: 0.5, y: 1)
                                    )
                                )
                                .cornerRadius(15)
                                .frame(height:
                                    self.calculateHeight(minHeight: 95,
                                                         maxHeight: 200,
                                                         yOffset: gr.frame(in: .global).origin.y))
                                .overlay(
                                    //  Profile Name , Notification Bell and Points Counter displayed in a Horizontal Stack on top of Gradient
                                    ZStack{
                                        HStack{
                                            
                                            Button(
                                                action : {
                                                    
                                                }
                                            ){
                                                Image(systemName: "envelope")
                                                    .foregroundStyle(Color.black)
                                            }
                                            
                                            Button(
                                                action : {
                                                    
                                                }
                                            ){
                                                Image(systemName: "person.crop.circle")
                                                    .foregroundStyle(Color.black)
                                            }
                                            
                                            
                                            //  Profile Name
                                            HStack{
                                                //  Welcome & User Name
                                                HStack{
                                                    Text("Hey,Welcome")
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(.black)
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                   
                                                     if let profile = userProfile.userProfile {
                                                     Text("\(profile.user_name ?? "")!")
                                                     .multilineTextAlignment(.center)
                                                     .foregroundColor(.black)
                                                     .font(.headline)
                                                     .fontWeight(.bold)
                                                     }
                                            
                                                }
                                            }
                                            .padding([.leading,.trailing])
                                            
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
                                            .frame(width: 70, height: 80)
                                        }
                                        .opacity(mainHeaderOpacity)
                                        
                                        HStack{
                                            HStack{
                                                Text("Hey,Welcome")
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.black)
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                 if let profile = userProfile.userProfile {
                                                 Text("\(profile.user_name ?? "")!")
                                                 .multilineTextAlignment(.center)
                                                 .foregroundColor(.black)
                                                 .font(.headline)
                                                 .fontWeight(.bold)
                                                 }
                                                 
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
                                                
                                            }
                                            .frame(height : 95)
                                            .padding(.top, 45)
                                            .padding([.leading, .trailing], 10)
                                            .frame(maxWidth: .infinity)
                                        }
                                        .opacity(subHeaderOpacity)
                                    }
                                )
                            // Offset just on the Y axis
                           .offset(y: gr.frame(in: .global).origin.y < 0 // Is it going up?
                               ? abs(gr.frame(in: .global).origin.y) // Push it down!
                               : -gr.frame(in: .global).origin.y) // Push it up!
                            Spacer() // Push header to top
                        }
                        
                    }
                     // End of ZStack
                 }
                
                //  End of ScrollView
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    func SignOutUser() {
        Task{
            do{
                try await Constants.API.supabaseClient.auth.signOut()
            }
        }
    }
    func calculateHeight(minHeight: CGFloat, maxHeight: CGFloat, yOffset: CGFloat) -> CGFloat {
        // If scrolling up, yOffset will be a negative number
        //  yOffset == 0, mainHeaderOpacity = 1
        let interpolatedOpacity = interpolate(value: headerHeight, from: 95...200, to: 0...1)
        mainHeaderOpacity = interpolatedOpacity
        subHeaderOpacity = 1 - interpolatedOpacity
        
        if maxHeight + yOffset < minHeight {
            // SCROLLING UP
            // Never go smaller than our minimum height
            headerHeight = minHeight
            return minHeight
        }
        
        // SCROLLING DOWN
        headerHeight = maxHeight + yOffset
        return maxHeight + yOffset
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

final class ContentViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.752655, longitude: -73.977295), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    
    var locationManager : CLLocationManager?
    
    func checkIfLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.activityType = .automotiveNavigation
            locationManager!.delegate = self
        }
        else{
            print("Location Off")
        }
    }
    
    func checkLocationAuthorizationStatus() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization( )
        case .restricted, .denied:
                print("Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            cameraPosition = .region(MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
    
}



/*
 VStack{
     ZStack(alignment: .top){
         //  Background Linear Gradient
         Rectangle()
             .foregroundColor(.clear)
             .frame(width: 430, height: 200)
             .background(
                 LinearGradient(
                     stops: [
                         Gradient.Stop(color: Color(red: 0.83, green: 0.72, blue: 0.58), location: 0.00),
                         Gradient.Stop(color: .white, location: 1.00),
                     ],
                     startPoint: UnitPoint(x: 0.5, y: 0),
                     endPoint: UnitPoint(x: 0.5, y: 1)
                 )
             )
             .cornerRadius(15)
         
         //  Profile Name , Notification Bell and Points Counter displayed in a Horizontal Stack on top of Gradient
         HStack{
             
             Button(
                 action : {
                     
                 }
             ){
                 Image(systemName: "envelope")
                     .foregroundStyle(Color.black)
             }
             
             Button(
                 action : {
                     
                 }
             ){
                 Image(systemName: "person.crop.circle")
                     .foregroundStyle(Color.black)
             }
             
             
             //  Profile Name
             HStack{
                 //  Welcome & User Name
                 HStack{
                     Text("Hey,Welcome")
                         .multilineTextAlignment(.center)
                         .foregroundColor(.black)
                         .font(.headline)
                         .fontWeight(.bold)
                     if let profile = userProfile.userProfile {
                         Text("\(profile.user_name ?? "")!")
                             .multilineTextAlignment(.center)
                             .foregroundColor(.black)
                             .font(.headline)
                             .fontWeight(.bold)
                     }
                 }
             }
             .padding([.leading,.trailing])
             
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
             .frame(width: 70, height: 80)
         }
         .padding(.top, 55)
     }
 }
  
 */
