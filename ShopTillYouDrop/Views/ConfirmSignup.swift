//
//  ConfirmSignup.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-21.
//

import Foundation
import SwiftUI
import Amplify

struct ConfirmSignUpView: View {
    // 1
    let username: String
    
    @State var confirmationCode: String = ""
    @State var shouldShowLogin: Bool = false
    
    var body: some View {
        VStack (spacing: 30){
            
            Text("Verification")
                .fontWeight(.bold)
                .font(Font.system(size: 50))
                .foregroundColor(Color.blue)
                .padding(.bottom, 100)
            
            
            VStack (spacing:25){
                TextField("Verification Code", text: $confirmationCode)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5).frame(height: 45))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                Task {
                    await confirmSignUp()
                }
                
            }){
                Text("Submit")
                    .modifier(CustomTextM(fontName: "MavenPro-Bold", fontSize: 16, fontColor: Color.white))
                
                    .frame(maxWidth: .infinity)
                    .frame(height: 56, alignment: .leading)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            
            
        }
        .padding(.horizontal,30)
        .padding(.vertical, 25)
        // 2
        .navigationDestination(isPresented: .constant(shouldShowLogin)) {
            LoginView()
        }
    }
    
    func confirmSignUp() async {
        do {
            // 1
            let result = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            switch result.nextStep {
            // 2
            case .done:
                DispatchQueue.main.async {
                    self.shouldShowLogin = true
                }
            default:
                print(result.nextStep)
            }
        } catch {
            print(error)
        }
    }
}




struct Previews_ConfirmSignup_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSignUpView(username: "Muaz")
    }
}
