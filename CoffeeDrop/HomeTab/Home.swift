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
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            ScrollView(.vertical, showsIndicators: false){
             VStack{
                ZStack(alignment: .top){
                    //  BackGround Linear Gradient
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
                                Text("Hey,Welcome ")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                if let profile = userProfile.userProfile {
                                    Text("\(profile.user_name ?? "")!")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .font(.subheadline)
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
                //End of HomeView Top Bars
                
                //  Cafe Searchbar
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
                    .frame(width: width * 0.85, height: 49)
                //  End of Cafe Searchbar
                
                //  CoffeeDrop Card
                CoffeeDropCard()
                    .frame(width: width * 0.9, height: 200, alignment: .center)
                    .offset(x : -10)
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
                
                Spacer()
            }
        }
            .ignoresSafeArea(edges : .top)
            .scrollBounceBehavior(.basedOnSize)
        }
        .environmentObject(userProfile) // VERY IMPORTANT: Supply UserProfile to the Home view
    }
    func SignOutUser() {
        Task{
            do{
                try await Constants.API.supabaseClient.auth.signOut()
            }
        }
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

