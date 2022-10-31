//
//  CardView.swift
//  SocialLoginPOC
//
//  Created by Anwesh M on 31/10/22.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = .black
    @IBInspectable var shadowRadius: CGFloat = 2
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var borderWidth: CGFloat = 0.5
    @IBInspectable var borderColor: UIColor? = .clear
    
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    
}
