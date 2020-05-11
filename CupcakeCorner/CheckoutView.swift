//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Cathal Farrell on 08/05/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {

    @ObservedObject var order: Order

    @State private var confirmationTitle = ""
    @State private var confirmationMessage = ""
    @State private var showAlert = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width)

                    Text("Your total is: €\(self.order.cost, specifier: "%.2f")")

                    Button("Place order"){
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(confirmationTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }

    /*
       Challenge 2 - If our call to placeOrder() fails – for example if there is no internet connection
       – show an informative alert for the user.
       To test this, just disable WiFi on your Mac so the simulator has no connection either.
    */

    func placeOrder() {

        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {

                if let response = response as? HTTPURLResponse {
                    print("Response STATUS code: \(response.statusCode)")
                }
                // handle the result here.
                guard let data = data else {
                    self.decodeError(error: error)
                    return
                }

                self.decodeResponse(data)
            }

            
        }.resume()
    }

    fileprivate func decodeResponse(_ data: Data) {
        //Decode response
        if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
            self.confirmationTitle = "Thank you!"
            self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            self.showAlert = true
        } else {
            print("Invalid response from server")
        }
    }

    fileprivate func decodeError(error: Error?) {
        if let error = error {
            print("🛑 No data in response. Error: \(error.localizedDescription)")
            self.confirmationTitle = "Request Failed"
            self.confirmationMessage = error.localizedDescription
            self.showAlert = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyOrder = Order()
        return CheckoutView(order: dummyOrder)
    }
}
