//
//  Order.swift
//  CupcakeCorner
//
//  Created by Cathal Farrell on 08/05/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import Foundation

class Order: ObservableObject, Codable {

    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAdress, city, eircode
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        //Must ensure if disabled that the following also reset
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false

    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var eircode = ""

    /*

     Challenge 1 - Our address fields are currently considered valid if they contain anything,
     even if it’s just only whitespace.

     Improve the validation to make sure a string of pure whitespace is invalid.

     */

    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty ||
            streetAddress.trimmingCharacters(in: .whitespaces).isEmpty ||
            city.trimmingCharacters(in: .whitespaces).isEmpty ||
            eircode.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }

    var cost: Double {
        // €2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // €1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // €0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }

    init() {
        //Required to allow an empty Order Instance for dummy views etc
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAdress)
        city = try container.decode(String.self, forKey: .city)
        eircode = try container.decode(String.self, forKey: .eircode)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)

        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAdress)
        try container.encode(city, forKey: .city)
        try container.encode(eircode, forKey: .eircode)
    }

}
