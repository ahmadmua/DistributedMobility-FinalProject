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
        return Coordinator(parent: self)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        var parent: LibraryPicker

        init(parent: LibraryPicker) {
            self.parent = parent
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



    }
}
