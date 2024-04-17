//
//  Scan.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-25.
//

import Foundation

import SwiftUI
import Photos
import PhotosUI
import UIKit
import Amplify


struct Scan: View {
    
    @State private var selection: Int? = nil
    
    @State private var input: String = ""

    @State private var profileImage : UIImage?
    @State private var permissionGranted : Bool = false
    @State private var showSheet : Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    @ObservedObject var classifier: ImageClassifier = ImageClassifier()
    @EnvironmentObject var userState: UserState
    
    @State private var showingSheet : Bool = false

    var body: some View {

        NavigationView{
            
            VStack{
                
                NavigationLink(destination: ProductView(input: input), tag: 5, selection: self.$selection){}
                
                Text("Select a Photo")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .underline()
                    .padding(.top, 55)
                    .foregroundColor(Color.blue)
                
                
                
                Image(uiImage: (profileImage ?? UIImage(systemName: "photo"))!)
                    .resizable()
                    .frame(width: 315, height: 315)
                
                Button(action: {
                    if(self.permissionGranted){
                        self.showSheet = true
                    }else{
                        self.requestPermissions()
                    }
                }){
                    Text("Upload Photo")
                }
                .actionSheet(isPresented: $showSheet){
                    ActionSheet(title: Text("Select Photo"),
                                message: Text("Choose photo to upload"),
                                buttons: [
                                    .default(Text("Choose from Photo Library")){
                                        self.showPicker = true
                                    },
                                    .default(Text("Take a Photo from Camera")){
                                        guard UIImagePickerController.isSourceTypeAvailable(.camera)
                                        else{
                                            print(#function, "Camera is not available")
                                            return
                                        }
                                        print(#function, "Camera is available")
                                        selection = 1
                                    },
                                    .cancel()
                                ]
                    )
                }
                .padding(.top, 35)
                .padding(.bottom, 55)
                
                
                TextField("Search Product...", text: $input)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue, lineWidth: 3)
                        
                    )
                    .frame(width:  UIScreen.main.bounds.width - 150)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.words)
                    .offset(x: 0, y:-30)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        self.selection = 5
                    }) {
                        Text("SEARCH")
                            .modifier(CustomTextM(fontName: "MavenPro-Bold", fontSize: 16, fontColor: Color.white))
                            .frame(maxWidth: 200)
                            .frame(height: 70, alignment: .leading)
                            .background(Color.blue)
                            .cornerRadius(7)
                            .offset(x: 0, y:-40)
                    }
                    .disabled(input.isEmpty)
                    .opacity(input.isEmpty ? 0.5 : 1.0)
                }
                
                Spacer()
                
            }
            .offset(y: 0)
            .fullScreenCover(isPresented: $showPicker){
                if(isUsingCamera){
                    //show camera selction
                }else{
                    LibraryPicker(selectedImage: self.$profileImage, isPresented: self.$showPicker, input: self.$input)
                }
            }
            .onAppear(){
                checkPermissions()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            Task {
                                await signOut()
                            }
                        }) {
                            
                            HStack {
                                Text(userState.username)
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                            
                        }
                }
            }
            
            
        }
        
    }

    private func checkPermissions(){
        switch PHPhotoLibrary.authorizationStatus(){
        case .authorized:
            self.permissionGranted = true
        case .denied, .notDetermined, .restricted, .limited:
            self.requestPermissions()
        @unknown default:
            break
        }
    }

    private func requestPermissions(){
        PHPhotoLibrary.requestAuthorization{status in
            switch status{
            case .authorized:
                self.permissionGranted = false

            case .denied, .notDetermined:
                return

            case .restricted:
                return
            case .limited:
                return
            @unknown default:
                return
            }
        }
    }
    
    func signOut() async {
        do {
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            _ = try await Amplify.DataStore.clear()
        } catch {
            print(error)
        }
    }
}

