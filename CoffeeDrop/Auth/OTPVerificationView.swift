//
//  OTPVerificationView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/4/25.
//  Screen for Users to enter the 6-digit OTP Code we send to thier phone number

import SwiftUI
import Combine
//  OTPModifer to go from one inputfield to the next
struct OtpModifier: ViewModifier {
    
    @Binding var pin : String
    
    var textLimit = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    
    //MARK -> BODY
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimit)}
            .frame(width: 45, height: 45)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("blueColor"), lineWidth: 2)
            )
    }
}

struct OTPVerificationView: View {
    //MARK -> PROPERTIES
    
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
    }
    
    @FocusState private var pinFocusState : FocusPin?
    @State private var pinOne : String = ""
    @State private var pinTwo : String = ""
    @State private var pinThree : String = ""
    @State private var pinFour:  String = ""
    @State private var pinFive : String = ""
    @State private var pinSix : String = ""
    @State private var result: Result<Void, Error>?
    @State var phoneNumber : String = ""
    @State private var showAlert : Bool = false
    private var isOTPValid : Bool {
        return pinOne.count == 1 && pinTwo.count == 1 && pinThree.count == 1 && pinFour.count == 1 && pinFive.count == 1 && pinSix.count == 1
    }
    private var OTPCode : String {
        return pinOne + pinTwo + pinThree + pinFour + pinFive + pinSix
    }
    //MARK -> BODY
    var body: some View {
            VStack {
                
                Group{
                    VStack(spacing : 0){
                        Text("Verification")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundColor(Color(red: 0.09, green: 0.11, blue: 0.18))
                            .padding(.top)
                        Text("Enter the OTP code we sent you")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                            .padding(.top, 15)
                    }
                    .frame(width : 380, alignment: .leading)
                }
                .padding([.leading, .top])
                //  OTP Input Field
                HStack(spacing:15, content: {
                    
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 48, height: 61)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .cornerRadius(10)
                        .overlay(
                            TextField("", text: $pinOne)
                                .modifier(OtpModifier(pin:$pinOne))
                                .onChange(of: pinOne){oldState, newVal in
                                    if (newVal.count == 1) {
                                        pinFocusState = .pinTwo
                                    }else {
                                        if (newVal.count == 0) {
                                            pinFocusState = .pinOne
                                        }
                                    }
                                }
                                .focused($pinFocusState, equals: .pinOne)
                            )
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 48, height: 61)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .cornerRadius(10)
                        .overlay(
                        TextField("", text:  $pinTwo)
                            .modifier(OtpModifier(pin:$pinTwo))
                            .onChange(of: pinTwo){oldState, newVal in
                                if (newVal.count == 1) {
                                    pinFocusState = .pinThree
                                }else {
                                    if (newVal.count == 0) {
                                        pinFocusState = .pinOne
                                    }
                                }
                            }
                            .focused($pinFocusState, equals: .pinTwo)
                        )
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 48, height: 61)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .cornerRadius(10)
                        .overlay(
                        TextField("", text:$pinThree)
                            .modifier(OtpModifier(pin:$pinThree))
                            .onChange(of: pinThree){oldState, newVal in
                                if (newVal.count == 1) {
                                    pinFocusState = .pinFour
                                }else {
                                    if (newVal.count == 0) {
                                        pinFocusState = .pinTwo
                                    }
                                }
                            }
                            .focused($pinFocusState, equals: .pinThree)
                        )
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 48, height: 61)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .cornerRadius(10)
                        .overlay(
                            TextField("", text: $pinFour)
                                .modifier(OtpModifier(pin:$pinFour))
                                .focused($pinFocusState, equals: .pinFour)
                                .onChange(of:pinFour){oldState, newVal in
                                    if (newVal.count == 1) {
                                        pinFocusState = .pinFive
                                    }else {
                                        if (newVal.count == 0) {
                                            pinFocusState = .pinThree
                                        }
                                    }
                                }
                        )
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 48, height: 61)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .cornerRadius(10)
                        .overlay(
                            TextField("", text: $pinFive)
                                .modifier(OtpModifier(pin:$pinFive))
                                .focused($pinFocusState, equals: .pinFive)
                                .onChange(of:pinFive){oldState, newVal in
                                    if (newVal.count == 1) {
                                        pinFocusState = .pinSix
                                    }else {
                                        if (newVal.count == 0) {
                                            pinFocusState = .pinFour
                                        }
                                    }
                                }
                        )
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 48, height: 61)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                        .cornerRadius(10)
                        .overlay(
                            TextField("", text: $pinSix)
                                .modifier(OtpModifier(pin:$pinSix))
                                .focused($pinFocusState, equals: .pinSix)
                                .onChange(of:pinSix){oldState, newVal in
                                    if (newVal.count == 0) {
                                        pinFocusState = .pinFive
                                    }
                                }
                        )
                    
                        
                })
                .padding(.vertical)
                //  End of OTP input field
                
                Button(action: {
                    if isOTPValid {
                        VerifyOTP()
                    } else{
                        showAlert = true
                    }
                }, label: {
                    ZStack{
                        Circle()
                            .frame(width: 64, height: 64)
                            .foregroundStyle(Color(red: 0.54, green: 0.32, blue: 0.16))
                        Image(systemName: "arrow.right")
                            .font(Font.title.weight(.semibold))
                            .foregroundStyle(Color.white)
                            .frame(width: 40, height: 40)
                    }
                })
                .padding(15)
                .clipShape(Capsule())
                .padding()
                
                
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Invalid OTP"), dismissButton: .default(Text("OK")))
            }
    }
    func VerifyOTP(){
        Task{
            do{
                try await Constants.API.supabaseClient.auth.verifyOTP(
                    phone: "+1"+phoneNumber,
                    token: OTPCode,
                  type: .sms
                )
                result = .success(())
            }
            catch{
                result = .failure(error)
                  print(result)
            }
        }
    }
}


