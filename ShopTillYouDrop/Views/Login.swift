//
//  Login.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-21.
//

import Foundation
import SwiftUI
import Amplify

struct LoginView: View {
    // 1
    @State var username: String = ""
    @State var password: String = ""
    @State private var showingAlert = false
    @State private var msg = ""
    // 2
    @State var shouldShowSignUp: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack (spacing:30){
                Spacer()
                
                Text("LOGIN")
                    .fontWeight(.bold)
                    .font(Font.system(size: 50))
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 100)
                
                
                // Form
                VStack(spacing: 25){
                    TextField("Username", text: $username)
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
                
                // SignIn
                Button(action: {
                    Task {
                        await login()
                        
                    }
                }){
                    Text("Sign In")
                        .modifier(CustomTextM(fontName: "MavenPro-Bold", fontSize: 16, fontColor: Color.white))
                    
                        .frame(maxWidth: .infinity)
                        .frame(height: 56, alignment: .leading)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.disabled(username.isEmpty || password.isEmpty)
                    .opacity(username.isEmpty || password.isEmpty ? 0.5 : 1.0)
                    .alert("\(msg)", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                
                Spacer()
                
                // SignUp
                VStack(spacing: 10){
                    Text("Don't have an account?")
                        .modifier(CustomTextM(fontName: "Oxygen-Regular", fontSize: 18, fontColor: Color.primary))
                    Button(action: {
                        shouldShowSignUp = true
                    }){
                        Text("Register")
                            .modifier(CustomTextM(fontName: "Oxygen-Bold", fontSize: 18, fontColor: Color.blue))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal,30)
            .padding(.vertical, 25)
               
            .navigationDestination(isPresented: $shouldShowSignUp) {
                SignUpView(showLogin: { shouldShowSignUp = false })
                    .navigationBarBackButtonHidden(true)
            }
            
            .onAppear {
                msg = "Error"
            }
        }
    }
    
    func login() async {
        do {
            let result = try await Amplify.Auth.signIn(
                username: username,
                password: password
            )
            switch result.nextStep {
            case .done:
                print("login is done")
            default:
                print(result.nextStep)
            }
        } catch {
            let errorMessage = "\(error)"
            if let firstLine = errorMessage.components(separatedBy: "\n").first {
                msg = firstLine
            } else {
                msg = errorMessage
            }
            showingAlert = true
            print(error)
        }
    }

}


struct Previews_Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
