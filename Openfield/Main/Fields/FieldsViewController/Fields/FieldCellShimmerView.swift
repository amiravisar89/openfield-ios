//
//  FieldCellShimmerView.swift
//  Openfield
//
//  Created by amir avisar on 27/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit

class FieldCellShimmerView: UITableViewCell {
  
  @IBOutlet var shimerView1: AppShimmerView!
  @IBOutlet var shimerView2: AppShimmerView!
  @IBOutlet var shimerView3: AppShimmerView!
  @IBOutlet var shimerView4: AppShimmerView!
  @IBOutlet var shimerView5: AppShimmerView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = R.color.screenBg()!
    startShimmer()
  }
  
  func startShimmer() {
    shimerView1.startShimmering()
    shimerView2.startShimmering()
    shimerView3.startShimmering()
    shimerView4.startShimmering()
    shimerView5.startShimmering()
  }
  
  func stopShimmer() {
    shimerView1.stopShimmering()
    shimerView2.stopShimmering()
    shimerView3.stopShimmering()
    shimerView4.stopShimmering()
    shimerView5.stopShimmering()
  }
  
}
