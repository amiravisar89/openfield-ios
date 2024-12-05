//
//  BaseView.swift
//  LottoMatic
//
//  Created by amir avisar on 29/01/2022.
//

import Foundation
import UIKit

class BaseView : UIView {
    
    func loadFromNib(nibName : String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
