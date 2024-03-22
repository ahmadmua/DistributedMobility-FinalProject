//
//  Signup.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-21.
//

import Foundation
import SwiftUI
import Amplify

struct SignUpView: View {
    // 1
    let showLogin: () -> Void
    
    @State var username: String = ""
    @State var email: String = ""
    // 2
    @State var password: String = ""
    @State var shouldShowConfirmSignUp: Bool = false
    @State private var showingAlert = false
    @State private var msg = ""
    
    var body: some View {
        VStack (spacing: 30){
            
            Spacer()
            
            Text("REGISTER")
                .fontWeight(.bold)
                .font(Font.system(size: 50))
                .foregroundColor(Color.blue)
                .padding(.bottom, 100)
            
            
            // Form
            VStack(spacing: 25){
                TextField("Email", text: $username)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5).frame(height: 45))
                    .multilineTextAlignment(.center)
                
                VStack(spacing:10){
                    SecureField("Password", text: $password)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5).frame(height: 45))
                        .multilineTextAlignment(.center)
                    
                }
            }
            
            // SignUp
            Button(action: {
                Task {
                    await signUp()
                }
                
            }){
                Text("Sign Up")
                    .modifier(CustomTextM(fontName: "MavenPro-Bold", fontSize: 16, fontColor: Color.white))
                
                    .frame(maxWidth: .infinity)
                    .frame(height: 56, alignment: .leading)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(self.msg, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
            
            Spacer()
            
            // SignUp
            VStack(spacing: 10){
                Text("Already have an account?")
                    .modifier(CustomTextM(fontName: "Oxygen-Regular", fontSize: 18, fontColor: Color.primary))
                Button(action: {
                    showLogin()
                }){
                    Text("Login")
                        .modifier(CustomTextM(fontName: "Oxygen-Bold", fontSize: 18, fontColor: Color.blue))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal,30)
        .padding(.vertical, 25)
        .navigationDestination(isPresented: .constant(shouldShowConfirmSignUp)) {
            ConfirmSignUpView(username: username)
        }

        }
        // 3

    func signUp() async {
        // 1
        let options = AuthSignUpRequest.Options(
            userAttributes: [.init(.email, value: email)]
        )
        do {
            // 2
            let result = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
            
            switch result.nextStep {
            // 3
            case .confirmUser:
                DispatchQueue.main.async {
                    self.shouldShowConfirmSignUp = true
                }
            default:
                print(result)
            }
        } catch {
            print(error)
        }
    }
}

