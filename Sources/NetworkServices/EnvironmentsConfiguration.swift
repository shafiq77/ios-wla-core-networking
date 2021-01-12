//
//  EnvironmentsConfiguration.swift
//  Network
//
//  Created by Vigneshkarthik Natarajan on 28/12/2020.
//

import Foundation

public class EnvironmentsConfiguration: NSObject {
    public static let shared: EnvironmentsConfiguration = EnvironmentsConfiguration()
    public var environmentConfigData: NSDictionary?
    
    public class func getValue(for key: String) -> String {
        if let dict = EnvironmentsConfiguration.shared.environmentConfigData,
           let urlString = dict[key] as? String {
            return urlString
        }
        return ""
    }
}
