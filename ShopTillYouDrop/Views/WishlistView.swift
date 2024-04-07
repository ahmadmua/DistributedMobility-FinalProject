import SwiftUI
import Amplify


struct WishlistView: View {
    
    @State private var wishlistItems: [ProductDataState] = []
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        
        NavigationView {
            
            List(wishlistItems, id: \.product_id) { product in
                
                HStack {
                    VStack(alignment: .trailing) {
                        
                        HStack {
                            Text(product.product_title!)
                                .font(.headline)
                            Spacer()
                        }
                        
                        HStack {
                            Text((product.offer?.store_name!)!)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text(product.offer!.price!)
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
        .onAppear(perform: fetchData)
    }
    
    func fetchData() {
        Task {
            do {
                let items = try await Amplify.DataStore.query(ProductDataState.self, where: ProductDataState.keys.userId == userState.userId)
                wishlistItems = items
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }

    
    
    func deleteAllProductData() async {
        do {
            let products = try await Amplify.DataStore.query(ProductDataState.self, where: ProductDataState.keys.userId == userState.userId)
            for product in products {
                try await Amplify.DataStore.delete(product)
            }
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

