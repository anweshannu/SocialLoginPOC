//
//  UIButton.swift
//  SocialLoginPOC
//
//  Created by Anwesh M on 31/10/22.
//

import Foundation
import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    @IBInspectable var sizeImage: CGSize {
        get {
            return self.imageView?.image?.size ?? CGSize.zero
        }
        set {
            if let image = self.imageView?.image {
                let imgUpdate = image.resizedImage(Size: newValue)
                self.setImage(imgUpdate, for: .normal)
            }
        }
    }
}
