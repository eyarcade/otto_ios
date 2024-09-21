//
//  LogoMapping.swift
//  otto3
//
//  Created by Cade on 9/15/24.
//

import UIKit

struct LogoMapping {
    static let vehicleLogos: [String: String] = [
        "Audi": "audi",
        "Toyota": "toyota",
        "Ford": "ford",
        "BMW": "bmw",
        "Nissan": "nissan",
        
    ]
    
    static func getLogo(for make: String) -> UIImage? {
        let logoName = vehicleLogos[make] ?? "default-logo" // default if vehicle and logo are not found
        return UIImage(named: logoName)
    }

}
