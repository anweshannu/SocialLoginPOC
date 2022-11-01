    //
    //  Extensions.swift
    //  SocialLoginPOC
    //
    //  Created by Anwesh M on 31/10/22.
    //

import UIKit

extension UIImage
{
    func resizedImage(Size sizeImage: CGSize) -> UIImage?
    {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}


extension UIButton{
    
    func addLeadingImageToButton(imageName: String, size: CGSize = CGSize(width: 20, height: 20)) {
        let icon = UIImage(named: imageName)?.resizedImage(Size: size)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.buttonSize = .medium
            config.cornerStyle = .medium
            config.image = icon
            config.imagePadding = 10
            config.imagePlacement = .leading
            config.preferredSymbolConfigurationForImage
            = UIImage.SymbolConfiguration(scale: .medium)
            
            config.title = self.titleLabel?.text
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 12)
                return outgoing
            })
            
            self.configuration = config
            
            
        } else {
                // Fallback on earlier versions
            self.setImage(icon, for: .normal)
            self.titleLabel?.font = .systemFont(ofSize: 12)
            self.titleLabel?.textAlignment = .left
        }
        
    }
    
    
    
}

extension UIEdgeInsets {
    
    /**
     Relatively adjusts the left and right parameters of a given UIEdgeInsets by the given values
     
     - parameter left:  The value to add to the left parameter of the edge inset
     - parameter right: The value to add to the right parameter of the edge inset
     
     - returns: The adjusted edge inset
     */
    func adjust(left: CGFloat, right: CGFloat) -> UIEdgeInsets {
        var edgeInsets = self
        edgeInsets.left += left
        edgeInsets.right += right
        
        return edgeInsets
    }
    
}


extension UIViewController {
  func showAlert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
