//
//  AnalysisLayerCell.swift
//  Openfield
//
//  Created by Daniel Kochavi on 19/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class AnalysisLayerCell: UIView {
    @IBOutlet private var contentView: UIView!

    @IBOutlet var layerPreview: UIImageView!
    @IBOutlet var cloudIcon: UIImageView!
    @IBOutlet var layerTitle: UILabel!

    public func bind(to layer: LayerCell) {
        contentView.layer.borderColor = layer.isSelected ? R.color.valleyBrand()!.cgColor : R.color.lightGrey()!.cgColor
        contentView.layer.borderWidth = 1
        layerTitle.text = layer.imageType.name()
        if layer.isEnabled {
            setImage(to: layer)
        } else {
            layerPreview.image = R.image.layer_off()!
        }
        let didFitType = (layer.issue?.issue == .clouds || layer.issue?.issue == .shadow)
        let isCloudHidden = layer.issue?.isHidden ?? true
        cloudIcon.isHidden = !(isCloudHidden == false && didFitType == true)
        layerTitle.textColor = !layer.isEnabled ? R.color.secondary() : R.color.primary()
        setupQA(layer: layer)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setupStaticColor() {
        contentView.backgroundColor = R.color.white()
    }

    private func setupQA(layer: LayerCell) {
        layerTitle.accessibilityIdentifier = "analysisLayer\(layer.imageType.name())"
    }

    private func setImage(to layer: LayerCell) {
        if let previewImage = layer.image,
           let url = URL(string: previewImage)
        {
            layerPreview.kf.setImage(with: url)
        } else {
            log.error("Failed to get preview image for layer: \(layer.imageType)")
        }
    }

    private func setup() {
        UINib(resource: R.nib.analysisLayerCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        setupStaticColor()
    }
}

extension AnalysisLayerCell {
    static func instanceFromNib() -> AnalysisLayerCell {
        let item = AnalysisLayerCell(frame: CGRect.zero)
        return item
    }
}
