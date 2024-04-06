//
//  LibraryPicker.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-25.
//

import Foundation
import SwiftUI
import PhotosUI

struct LibraryPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    @Binding var input: String

    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, input: $input)
    }
    
    init(selectedImage: Binding<UIImage?>, isPresented: Binding<Bool>, input: Binding<String>) {
        _selectedImage = selectedImage
        _isPresented = isPresented
        _input = input
    }

    class Coordinator: PHPickerViewControllerDelegate {
        var parent: LibraryPicker
        @Binding var input: String

        init(parent: LibraryPicker, input: Binding<String>) {  // Modify this line
            self.parent = parent
            _input = input  // Add this line
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let image = results.first else {
                return
            }

            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                image.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard error == nil, let selectedImage = image as? UIImage else {
                        print("Error: Unable to load image")
                        return
                    }

                    DispatchQueue.main.async {
                        self.parent.selectedImage = selectedImage
                        // Upload the selected image here
                        if let imageUrl = self.uploadImage(selectedImage) {
                            // Use the uploaded image URL here if needed
                            print("Image uploaded successfully: \(imageUrl)")
                            self.callRapidAPI(imageUrl: imageUrl) { title in
                                    DispatchQueue.main.async {
                                        // Update the input text field with the title
                                        self.parent.input = title ?? ""
                                    }
                                }
                        }
                    }
                }
            }
        }

        func uploadImage(_ image: UIImage) -> String? {
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                print("Error: Unable to convert image to JPEG data")
                return nil
            }

            let url = URL(string: "https://api.imgur.com/3/image")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Client-ID 4d17689b11b6983", forHTTPHeaderField: "Authorization")
            request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            request.httpBody = imageData

            var imageUrl: String?

            let semaphore = DispatchSemaphore(value: 0)

            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { semaphore.signal() }

                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let data = json["data"] as? [String: Any], let id = data["id"] as? String {
                                imageUrl = "https://i.imgur.com/\(id).jpeg"
                            } else if let error = json["error"] as? String {
                                print("Error from Imgur API: \(error)")
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }.resume()

            semaphore.wait()

            return imageUrl
        }

        func callRapidAPI(imageUrl: String, completion: @escaping (String?) -> Void) {
            let headers = [
                "X-RapidAPI-Key": "2f97e8506bmsh25356e3490e7c7bp1344f9jsn7720690c277c",
                "X-RapidAPI-Host": "real-time-lens-data.p.rapidapi.com"
            ]

            let url = URL(string: "https://real-time-lens-data.p.rapidapi.com/search?url=\(imageUrl)&language=en&country=us")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let data = json?["data"] as? [String: Any], let visualMatches = data["visual_matches"] as? [[String: Any]], let firstMatch = visualMatches.first {
                            if let title = firstMatch["title"] as? String {
                                   completion(title)
                               }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }

            dataTask.resume()
        }


    }

}
