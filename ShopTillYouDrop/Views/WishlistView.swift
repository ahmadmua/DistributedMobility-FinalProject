import SwiftUI
import Amplify
import AWSS3StoragePlugin

struct WishlistView: View {
    
    @State  var wishlistItems: [ProductDataState] = []
    @EnvironmentObject var userState: UserState
    //static let shared = WishlistView()
    @State private var images: [String: UIImage] = [:]
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(wishlistItems, id: \.product_id) { product in
                    
                    NavigationLink(destination: WishlistDetailView(wishlistItems: product)) {
                        
                        HStack {
                            
                            if let image = images[product.product_id ?? ""] {
                                Image(uiImage: image)
                                    .resizable().scaledToFit().frame(width: 50, height: 50)
                            } else {
                                Text("Loading Image...")
                            }
                            
                            //                            AsyncImage(url: URL(string: (product.product_photos?.first ?? "")!)) { image in
                            //                                image.resizable().scaledToFit().frame(width: 50, height: 50)
                            //                            } placeholder: {
                            //                                ProgressView()
                            //                            }
                            
                            VStack(alignment: .trailing) {
                                
                                HStack {
                                    Text(product.product_title!)
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(product.offer?.store_name! ?? "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text(product.offer?.price! ?? "N/A")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .frame(width: 9, height: 9)
                                    
                                    Text("\(String(format: "%.2f", product.product_rating ?? "N/A"))")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .onDelete(perform: deleteProduct)
                
            }
            .navigationTitle("Wishlist")
            .navigationBarItems(trailing:
                                    Button(action: {
                Task {
                    await deleteAllProductData()
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            )
        }
        //.onAppear(perform: fetchData)
        .onAppear(perform: fetchDataAndImages)
        
        
    }
    
    func fetchDataAndImages() {
        Task {
            do {
                let items = try await Amplify.DataStore.query(ProductDataState.self, where: ProductDataState.keys.userId == userState.userId)
                wishlistItems = items
                
                for product in wishlistItems {
                    if let productId = product.product_id {
                        await downloadImageFromS3(for: productId)
                    }
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    
    //    func fetchData() {
    //        Task {
    //            do {
    //                let items = try await Amplify.DataStore.query(ProductDataState.self, where: ProductDataState.keys.userId == userState.userId)
    //                wishlistItems = items
    //            } catch {
    //                print("Error fetching data: \(error)")
    //            }
    //        }
    //    }
    //
    
    
    func deleteProduct(at offsets: IndexSet) {
        Task {
            do {
                for index in offsets {
                    let product = wishlistItems[index]
                    try await Amplify.DataStore.delete(product)
                }
                wishlistItems.remove(atOffsets: offsets)
                print("Successfully deleted product")
            } catch {
                print("Error deleting product: \(error)")
            }
        }
    }
    
    func downloadImageFromS3(for productId: String) async {
        let key = "\(productId).jpg"
        print("Downloading image from S3 with key:", key)
        do {
            let imageData = try await Amplify.Storage.downloadData(key: key).value
            let image = UIImage(data: imageData)
            images[productId] = image
        } catch {
            print("Error downloading image from S3:", error)
        }
    }
    
    func deleteAllProductData() async {
        do {
            let products = try await Amplify.DataStore.query(ProductDataState.self, where: ProductDataState.keys.userId == userState.userId)
            for product in products {
                try await Amplify.DataStore.delete(product)
            }
            wishlistItems.removeAll()
            print("Successfully deleted all records")
        } catch {
            print("Error deleting all records: \(error)")
        }
    }
    
}
struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}
