//
//  SignUpView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//
import SwiftUI
struct SignUpView : View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Text("Sign Up")
       
        Button(action: {
            // This dismisses the current view, returning to the previous view (e.g., LoginView)
            dismiss()
        }) {
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
