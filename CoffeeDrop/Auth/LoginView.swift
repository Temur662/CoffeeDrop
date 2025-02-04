//
//  LoginView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//

import SwiftUI
struct LoginView : View {
    @Environment(\.dismiss) private var dismiss
    @State var email = ""
    @State var password = ""
    @State var isLoading = false
    @State var result: Result<Void, Error>?
    @State var isShowingPassword: Bool = false
    @FocusState var isFieldFocus: FieldToFocus?
    
    enum FieldToFocus {
        case secureField, textField
    }
    
    var body: some View {
        GeometryReader{ geo in
            let width = geo.size.width
            VStack{
                
                Group{
                    Text("Sign in")
                        .fontWeight(.semibold)
                        .font(.title)
                        .foregroundColor(Color(red: 0.09, green: 0.11, blue: 0.18))
                        .padding(.top)
                    Text("Welcome back")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
                
                Group{
                    //  Email Input Field
                    HStack{
                        Image(systemName: "envelope")
                            .frame(width: 18, height: 18)
                        Divider().frame(width: 1)
                            .background(Color(red: 0.76, green: 0.78, blue: 0.82))
                        TextField("Email address", text: $email)
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
                    //  Password Input Field
                    HStack{
                        Image(systemName: "lock")
                            .frame(width: 18, height: 18)
                        Divider().frame(width: 1)
                            .background(Color(red: 0.76, green: 0.78, blue: 0.82))
                            
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
                            Color(UIColor.systemGray4)
                                .frame(height: 1)
                        }
                    )
                }
                .background(Color.white)
                .scrollContentBackground(.hidden)
                .frame(width : width * 0.88, height : 50, alignment: .center)
                .padding(.top, 30)

                    //  End of Passport Input field
                    
                    //  Forgot Password
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.headline)
                            .underline(true, pattern: .solid)
                            .foregroundColor(Color(red: 0.2, green: 0.29, blue: 0.35))
                            .frame(alignment: .topLeading)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    //  Login Button
                    HStack{
                        Spacer()
                        Spacer()
                        NavigationLink(destination: SignUpView()){
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
                Spacer()
                NavigationLink(destination: SignUpView()){
                    HStack(spacing : 0){
                            Text("New Member?")
                                .foregroundColor(Color(red: 0.67, green: 0.67, blue: 0.67))
                            Text(" Sign Up")
                                .foregroundColor(Color(red: 0.2, green: 0.29, blue: 0.35))
                                .font(.headline)
                                .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding([.leading, .bottom], 35)
                }
                    
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
            .toolbar {
                 ToolbarItem(placement: .topBarLeading) {
                     Button(action: {
                         dismiss()
                     }) {
                         Label("Back", systemImage: "arrow.left")
                             .backgroundStyle(Color.black)
                     }
                 }
             }
    }
}
