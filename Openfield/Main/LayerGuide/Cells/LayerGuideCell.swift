//
//  LayerGuideCell.swift
//  Openfield
//
//  Created by Itay Kaplan on 06/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FSPagerView
import UIKit

struct LayerGuideCellInput {
    var layerImage: UIImage
    var layerName: String
    var colorMapImage: UIImage?
    var colorMapLowValue: String?
    var colorMapHighValue: String?
    var layerExplanation: String
    var learnMore: String
}

class LayerGuideCell: FSPagerViewCell {
    @IBOutlet var layerImage: UIImageView!
    @IBOutlet var layerName: UILabel!
    @IBOutlet var colorMapImage: UIImageView!
    @IBOutlet var colorMapLowValue: UILabel!
    @IBOutlet var colorMapHighValue: UILabel!
    @IBOutlet var layerExplanation: UILabel!
    @IBOutlet var learnMore: UILabel!

    @IBOutlet var testConstrain: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.layer.shadowRadius = 0
        layerImage.layer.cornerRadius = 15
        layerImage.layer.masksToBounds = true
    }

    func setLayerGuideCell(layerGuideCellInput: LayerGuideCellInput) {
        if layerGuideCellInput.colorMapImage == nil, layerGuideCellInput.colorMapLowValue == nil, layerGuideCellInput.colorMapHighValue == nil {
            if testConstrain != nil {
                testConstrain.isActive = false
            }
            colorMapImage.isHidden = true
            colorMapLowValue.isHidden = true
            colorMapHighValue.isHidden = true
        } else {
            if testConstrain != nil {
                testConstrain.isActive = true
            }
            colorMapImage.isHidden = false
            colorMapLowValue.isHidden = false
            colorMapHighValue.isHidden = false
        }

        layerImage.image = layerGuideCellInput.layerImage
        layerName.text = layerGuideCellInput.layerName
        colorMapImage.image = layerGuideCellInput.colorMapImage
        colorMapLowValue.text = layerGuideCellInput.colorMapLowValue
        colorMapHighValue.text = layerGuideCellInput.colorMapHighValue
        layerExplanation.text = layerGuideCellInput.layerExplanation
        learnMore.text = layerGuideCellInput.learnMore
    }
}
