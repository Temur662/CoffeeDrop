//
//  SignUpView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//
import SwiftUI
import Auth
import Combine
struct SignUpView : View {
    @Environment(\.dismiss) private var dismiss
    @State var email = ""
    @State var password = ""
    @State var isLoading : Bool = false
    @State var result: Result<Void, Error>?
    @State var isShowingPassword: Bool = false
    @State var phoneNumber = ""
    @State var userName = ""
    @FocusState var isFieldFocus: FieldToFocus?
    @State var showAlert = false
    @State private var isActive : Bool  = false
    @State private var updateUserResult : Result<Void,Error>?
    private var isFormFilledValid: Bool {
        return !email.isEmpty && !password.isEmpty && !userName.isEmpty && !phoneNumber.isEmpty && phoneNumber.count == 10
    }
    enum FieldToFocus {
        case secureField, textField
    }
    
    var body: some View {
        GeometryReader{ geo in
            let width = geo.size.width
            VStack{
                
                Group{
                    VStack(spacing : 0){
                        Text("Sign up")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundColor(Color(red: 0.09, green: 0.11, blue: 0.18))
                            .padding(.top)
                        Text("Create an account here")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                            .padding(.top, 15)
                    }
                    .frame(width : 380, alignment: .leading)
                }
                .padding([.leading, .top])
                //  Input Fields
                Group{
                    //  UserName Input Field
                    HStack{
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Divider().frame(width: 1)
                        TextField("User Name", text: $userName)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding(.vertical, 8)
                    .background(
                        VStack {
                            Spacer()
                            Color(Color(red: 0.76, green: 0.78, blue: 0.82))
                                .frame(height: 1)
                        }
                    )
                    
                    //  Mobile Number
                    HStack{
                        Image(systemName: "iphone.gen2")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Divider().frame(width: 1)
                        TextField("Mobile number", text: $phoneNumber)
                            .textContentType(.telephoneNumber)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad) // Numeric keyboard
                            .onChange(of: phoneNumber) {old, newValue in
                                // Filter out non-numeric characters
                                phoneNumber = newValue.filter { $0.isNumber }.prefix(10).description
                            }
                    }
                    .padding(.vertical, 8)
                    .background(
                        VStack {
                            Spacer()
                            Color(Color(red: 0.76, green: 0.78, blue: 0.82))
                                .frame(height: 1)
                        }
                    )
                    
                    
                    //  Email Input Field
                    HStack{
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Divider().frame(width: 1)
                        TextField("Email address", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                    }
                    .padding(.vertical, 8)
                    .background(
                        VStack {
                            Spacer()
                            Color(Color(red: 0.76, green: 0.78, blue: 0.82))
                                .frame(height: 1)
                        }
                    )
                    //  Password Input Field
                    HStack{
                        Image(systemName: "lock")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Divider().frame(width: 1)
                        Group{
                            if isShowingPassword {
                                TextField("Password", text: $password)
                                    .focused($isFieldFocus, equals: .textField)
                            }else {
                                SecureField("Password", text: $password)
                                    .focused($isFieldFocus, equals: .secureField)
                            }
                        }
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        
                        Button {
                            isShowingPassword.toggle()
                        }label: {
                            if isShowingPassword {
                                Image(systemName: "eye.slash")
                                    .foregroundStyle(Color.black)
                            }else {
                                Image(systemName: "eye")
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .frame(width: 18, height: 18)
                    }
                    .onChange(of: isShowingPassword) {
                        isFieldFocus = isShowingPassword ? .textField : .secureField
                    }
                    .padding(.vertical, 8)
                    .background(
                        VStack {
                            Spacer()
                            Color(Color(red: 0.76, green: 0.78, blue: 0.82))
                                .frame(height: 1)
                        }
                    )
                }
                .background(Color.white)
                .scrollContentBackground(.hidden)
                .frame(width : width * 0.88, height : 50, alignment: .center)
                .padding([.leading,.trailing])
                
                Text("By signing up you agree with our Terms of Use\n")
                  .foregroundColor(Color(red: 0.2, green: 0.29, blue: 0.35))
                  .frame(width: 285, height: 49, alignment: .topLeading)
                  .font(.body)
                  .padding(.top)
                
                Spacer()
                //  Login Button
                HStack{
                    Spacer()
                    Spacer()
                    NavigationStack{
                            Button(action: {
                                if isFormFilledValid {
                                    SignInWithPhoneOtp()
                                }else{
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
                            .padding(.trailing, 35)
                        }
                        .navigationDestination(isPresented: $isActive){
                            OTPVerificationView(phoneNumber: phoneNumber, password: password, email: email)
                    }
                }
                Spacer()
                Button(
                    action :{ dismiss() }
                ){
                    HStack(spacing : 0){
                        Text("Already a member?")
                            .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                        Text(" Sign In")
                            .foregroundColor(Color(red: 0.2, green: 0.29, blue: 0.35))
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 35)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Missing Information"),
                    message: Text("Please fill out all fields before submitting."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    func SignInWithPhoneOtp(){
        Task {
              isLoading = true
              defer { isLoading = false }

              do {
                  try await Constants.API.supabaseClient.auth.signInWithOTP(
                    phone: "+1" + phoneNumber,
                    data: [
                        "user_name": .string(userName),
                        "email": .string(email),
                        "phone_number": .string("+1" + phoneNumber),
                      ]
                  )
                  
                result = .success(())
                isActive = true
              } catch {
                result = .failure(error)
                isActive = false
              }
            }
          }
}

//  Tasks :

/*
    * Sign In User with Phone OTP
    * Save User Email and Password inputted so they could then login in with either phonenumber again or email / password
 
    - How do i do this with SupaBase
 
    What i know :
        Supabase makes a user row when i call SignInWithPhoneOTP
            - First Try Update Email and Password at this step ^
            - Attempt Result : Session is missing
            - Need to be logged into a session to update User Email and Password
        I only get logged in when i verify my accout and get authenticated status
        
        Login and verify then update email and password
        What i need: If User First time sign up run the UpdateEmail&Password()
            - How do I Pass email and password to that function so it can be called on sign in.
            - Second Try ^
 */
