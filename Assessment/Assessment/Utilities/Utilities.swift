//
//  Utilities.swift
//  Assessment
//
//  Created by Clavax on 27/04/24.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.tabBarController?.selectedIndex = 0
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
            
        
    func setShadowToView(view : UIView,CornerRadius:CGFloat,BorderColor:UIColor,BorderWidth:CGFloat,ShadowOpacity:Float,ShadowColor:UIColor,ShadowRadius:CGFloat,ShadowOffset:CGSize,MasksToBounds:Bool){
        
        view.layer.cornerRadius = CornerRadius
        view.layer.borderColor  =  BorderColor.cgColor
        view.layer.borderWidth = BorderWidth
        view.layer.shadowOpacity = ShadowOpacity
        view.layer.shadowColor = ShadowColor.cgColor
        view.layer.shadowRadius = ShadowRadius
        view.layer.shadowOffset = ShadowOffset
        view.layer.masksToBounds = MasksToBounds
        //  view.layer.shouldRasterize = true
        }
}
