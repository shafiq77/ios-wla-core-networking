//
//  ThemeHandler.swift
//  Theme
//
//  Created by Vigneshkarthik Natarajan on 23/12/2020.
//

import Foundation
import UIKit
import SwiftUI

public extension Color {
	static let shopHeaderColor = Color.init("ShopHeaderColor")
	static let shopBGColor = Color.init("ShopBGColor")
	static let saytDescriptionColor = Color.init("SAYTDescriptionColor")
	static let viewBackgroundPrimaryColor = Color("Gray 200")
	static let shopHeaderIndicatorPrimaryColor = Color("gg_color_green_500")
	static let shopSearchBarPlaceholderTextPrimaryColor = Color("Gray 600")
	static let cancelTextPrimaryColor = Color("Gray 700")
	static let listTextPrimaryColor = Color("Gray 800")
	static let clearTextPrimaryColor = Color("Gray 900")
	static let whiteColor = Color.white
	static let grayColorIcon = Color("gg_color_gray_Icon")
}

public extension Font {
	//Shop
	static let shopHeaderWelcomeFontBold = Font.largeTitle.bold()
	static let shopTabHeaderFont = Font.headline
	static let shopTabHeaderFontMedium = Font.system(size: 14.0, weight: .medium)
	//Search
	static let shopHeaderFont = Font.system(size: 21.0, weight: .regular)
	static let saytDescription = Font.system(size: 16.0, weight: .regular)
	static let shopHeaderFontBold = Font.system(size: 14.0, weight: .bold)
	static let topProductNameFont = Font.system(size: 10.0, weight: .regular)
	static let topProductPriceFontBold = Font.system(size: 10.0, weight: .bold)
	static let suggestionFontRegular = Font.system(size: 17.0, weight: .regular)
}

