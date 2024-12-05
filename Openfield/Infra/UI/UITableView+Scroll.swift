//
//  UITableView+Scroll.swift
//  Openfield
//
//  Created by amir avisar on 26/05/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToTop() {
        if visibleCells.count > 0 {
            scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func scrollToBottom(contentOffset: CGPoint, threshold: CGFloat = 100.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + threshold > self.contentSize.height
    }
}
