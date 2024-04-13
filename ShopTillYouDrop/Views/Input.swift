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
    
    @State private var showingSheet : Bool = false

    var body: some View {

        NavigationView{
            
            VStack{
                
                NavigationLink(destination: ProductView(input: input), tag: 5, selection: self.$selection){}
                
                Text("Select a photo")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .underline()
                    .padding(.top, 55)
                    .foregroundColor(Color.blue)
                
                
                
                Image(uiImage: (profileImage ?? UIImage(systemName: "photo"))!)
                    .resizable()
                    .frame(width: 315, height: 315)
                //                    .overlay(
                //                        Rectangle()
                //                            .stroke(Color.black, lineWidth: 2)
                //                            .padding(-50)
                //                    )
                
                Button(action: {
                    if(self.permissionGranted){
                        self.showSheet = true
                    }else{
                        self.requestPermissions()
                    }
                }){
                    Text("Upload Picture")
                }
                .actionSheet(isPresented: $showSheet){
                    ActionSheet(title: Text("Select Photo"),
                                message: Text("Choose photo to upload"),
                                buttons: [
                                    .default(Text("Choose from Photo Library")){
                                        // when user want to pick pic from the library
                                        self.showPicker = true
                                    },
                                    .default(Text("Take a Picture from Camera")){
                                        // when user want to open camera and click new pic
                                        //                        selection = 1
                                        guard UIImagePickerController.isSourceTypeAvailable(.camera)
                                        else{
                                            print(#function, "Camera is not available")
                                            return
                                        }
                                        
                                        print(#function, "Camera is available")
                                        //camera is available, open the  camera to allow taking pic
                                        selection = 1
                                        //                        self.isUsingCamera = true
                                        //                        self.showPicker = true
                                    },
                                    .cancel()
                                ]
                                
                    )//action sheet
                }//.actionsheet
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
                //            Button(action: {
                //                print("DO ML KIT")
                //
                //            }){
                //                Text("SCAN")
                //                    .modifier(CustomTextM(fontName: "MavenPro-Bold", fontSize: 16, fontColor: Color.white))
                //
                //                    .frame(maxWidth: 280)
                //                    .frame(height: 56, alignment: .leading)
                //                    .background(Color.blue)
                //                    .cornerRadius(7)
                //            }//button
                
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
                    
                    
                }
                
                
                //            Button("Show Sheet") {
                //                        showingSheet.toggle()
                //                    }
                //                    .sheet(isPresented: $showingSheet) {
                //                        SheetView()
                //                    }
                
                
                Spacer()
                
            }//vstack
            
            .offset(y: 0)
            .fullScreenCover(isPresented: $showPicker){
                if(isUsingCamera){
                    //show camera selction
                }else{
                    //open photoLibrary
                    LibraryPicker(selectedImage: self.$profileImage, isPresented: self.$showPicker, input: self.$input)
                    
                    
                }
            }
            .onAppear(){
                checkPermissions()
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
            // 1
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            // 2
            _ = try await Amplify.DataStore.clear()
        } catch {
            print(error)
        }
    }
}


//struct SheetView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var selection: Int? = nil
//    var product : String
//
//
//    var body: some View {
//
//
//
//        NavigationView{
//            VStack{
//
//                Spacer()
//
//                Text("Confirm Scan Results")
//                    .font(.largeTitle)
//
//                Spacer()
//
//                Text(product)
//                    .font(.title)
//
//                HStack{
//                    Button(action:{
//                        dismiss()
//                    }){
//                        Image(systemName: "xmark.circle")
//                            .font(.largeTitle)
//                    }
//                    Button(action:{
//
//                        selection = 2
//                        print("WHY")
//                    }){
//                        Image(systemName: "checkmark.circle")
//                            .font(.largeTitle)
//
//                    }
//
//                }
//
//                Spacer()
//            }//vstack
//        }
//    }
//
//}

