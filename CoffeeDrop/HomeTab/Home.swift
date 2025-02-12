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
    @Environment(\.dismiss) private var dismiss
    @StateObject private var locationManagerModel = ContentViewModel()
    @State private var searchText: String = ""
    @State private var hasCancel: Bool = true
    @State private var mainHeaderOpacity: CGFloat = 0
    @State private var subHeaderOpacity: CGFloat = 0
    @State private var headerHeight : CGFloat = 0
    @Binding var CurrentTab : Int
    var animation: Namespace.ID
    @State var GoToRewards: Bool = false
    
    var body: some View {
        NavigationStack{
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
                                                .overlay(
                                                    HStack(spacing : 0){
                                                        Image(.searchBarIcon)
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                        TextField("Search Café", text: $searchText)
                                                            .font(.system(size : 20))
                                                            .multilineTextAlignment(.leading)
                                                            .disableAutocorrection(true)
                                                            .foregroundColor(Color(red: 0.49, green: 0.49, blue: 0.49))
                                                            .frame(alignment : .leading)
                                                            .padding(.leading, 5)
                                                    }
                                                        .padding(.horizontal)
                                                )
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
                                    .frame(width: 120)
                                    .offset(x: -25)
                                    .mapStyle(.standard(elevation : .realistic))
                                    .onAppear {
                                        locationManagerModel.checkIfLocationServicesEnabled()
                                    }
                                    .onChange(of: locationManagerModel.cameraPosition) { oldState, value in
                                        userProfile.userLocation = value
                                    }
                                    .onTapGesture {pGesture in
                                        withAnimation { CurrentTab = 1 }
                                    }
                                    .matchedGeometryEffect(id: "Map", in: animation)
                                }
                                    .padding(.trailing, 8)
                            )
                            .frame( height: 49, alignment : .center )
                            .padding([.top,.leading], 15)
                        //  End of Cafe Searchbar
                        
                        //  CoffeeDrop Card
                        CoffeeDropCard(GoToRewards: $GoToRewards)
                            .frame( height: 200, alignment: .center)
                        //  End of CoffeDrop Card
                        
                        //  Cafes Near Me
                        HStack{
                            Text("Cafés Near You ")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .font(.headline)
                                .frame(alignment: .leading)
                                .padding([.top])
                            Spacer()
                            Spacer()
                        }
                        
                        CafesNearMeView()
                            .padding([.leading, .trailing])
                        
                        
                        QuickOrderCard()
                        
                        VStack{
                            Text("COFFEE")
                                .font(.largeTitle)
                                .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                .bold()
                            Text("DROP")
                                .font(.largeTitle)
                                .foregroundColor(Color(red: 0.54, green: 0.32, blue: 0.16))
                                .bold()
                        }
                        .padding(.top, 30)
                        
                        Button(
                            action: {
                                SignOutUser()
                            }
                        ) {
                            Label("Logout", systemImage: "xmark")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 150)
                    
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
                                                             maxHeight: 150,
                                                             yOffset: gr.frame(in: .global).origin.y))
                                .overlay(
                                    //  Profile Name , Notification Bell and Points Counter displayed in a Horizontal Stack on top of Gradient
                                    ZStack{
                                        
                                        VStack(spacing: 1){
                                            //  Main Header
                                            HStack{
                                                Group{
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
                                                }
                                                .padding(.leading)
                                                Spacer()
                                                //  Points Display With CoffeeBean
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
                                                    .frame(width: 70, height: 80)
                                            }
                                            //  Profile Name
                                            HStack{
                                                //  Welcome & User Name
                                                Text("Hey,Welcome")
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 23))
                                                    .fontWeight(.bold)
                                                
                                                if let profile = userProfile.userProfile {
                                                    Text("\(profile.user_name ?? "")!")
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 23))
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                            }
                                            .padding([.leading,.trailing])
                                        }
                                        .opacity(mainHeaderOpacity)
                                        
                                        
                                        HStack{
                                            //  Sub Header When Min Height
                                            HStack{
                                                Group{
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
                                                }
                                                .padding(.leading)
                                                HStack{
                                                    //  Welcome & User Name
                                                    Text("Hey,Welcome")
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(.black)
                                                        .font(.caption)
                                                    
                                                    if let profile = userProfile.userProfile {
                                                        Text("\(profile.user_name ?? "")!")
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(.black)
                                                            .font(.caption)
                                                    }
                                                }
                                                .padding([.leading,.trailing])
                                                //  Points Display With CoffeeBean
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
                                                    .frame(width: 70, height: 80)
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
            .navigationBarHidden(true) // Hide the Navigation Bar
            .edgesIgnoringSafeArea(.vertical) // Extend content to top safe area
        }
      
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
        let interpolatedOpacity = interpolate(value: headerHeight, from: minHeight...maxHeight, to: 0...1)
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
