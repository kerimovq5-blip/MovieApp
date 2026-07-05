//
//  AccentStyle_Colorset.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 28.06.26.
//




import UIKit


enum AssetColors : String{
    
    case mainbackground = "MainBackground"
    case backgroundSecondary = "BackgroundSecondary"
    case searchBackground = "searchBackground"
    case searchcolor = "searchcolor"
    var color : UIColor {
        return UIColor(named: self.rawValue) ?? .clear
        
    }
    
}

extension UIColor  {
    func assetColor( _ colorName : AssetColors) -> UIColor {
        return colorName.color
    }
    
}

enum AppStyle {
    enum AppFonts {
        static let title = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
        
    }
    enum AppSpacing {
        static let xsmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
    }
    enum AppRaduis {
        static let buttonRadius: CGFloat = 30
        static let buttonRadiusSmall: CGFloat = 15
    }

}

