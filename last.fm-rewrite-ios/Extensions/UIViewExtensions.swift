//
//  UIViewExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 02.04.2022..
//

import UIKit

extension UIView {
    
    //MARK: - XIBs
    //https://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
    
    public class var nibName: String {
        var name = "\(self)".components(separatedBy: ".").first ?? ""
        name = name.components(separatedBy: "<").first ?? ""
        return name
    }
    
    public class var nib: UINib {
        return UINib.init(nibName: nibName, bundle: nil)
    }

    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
