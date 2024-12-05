//
//  FieldCategoryCell.swift
//  Openfield
//
//  Created by Yoni Luz on 28/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import Resolver
import RxSwift

class FieldCategoryCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIView!
    @IBOutlet var dotView: UIView!
    @IBOutlet weak var insightName: UILabel!
    @IBOutlet weak var summeryText: UILabel!
    @IBOutlet weak var trendImage: UIImageView!
    @IBOutlet weak var trendValue: UILabel!
    @IBOutlet weak var insightsNames: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var nextButton: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var trendContainerStack: UIStackView!
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var tagImage: TagImageViewer!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var locationsImage: LocationsImageViewer!
    @IBOutlet weak var trendStack: UIView!
    
    var uiElement : FieldCategoryCellUiElement!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagImage.clearTags()
        locationsImage.clearDots()
    }
    
    func bind(to uiElement: FieldCategoryCellUiElement) {
        self.uiElement = uiElement
        insightName.font = uiElement.read ? R.font.avertaRegular(size: insightName.font.pointSize) : R.font.avertaSemibold(size: insightName.font.pointSize)
        dotView.isHidden = uiElement.read
        timeAgo.text = uiElement.date
        insightName.text = uiElement.title
        insightsNames.text = uiElement.content
        highlightLabel.text = uiElement.highlightedText
        highlightView.isHidden = !uiElement.highlighted
        trendStack.isHidden = uiElement.highlighted
        insightsNames.isHidden = uiElement.highlighted
        tagImage.imageContentMode = .scaleToFill
        handleTrend(summery: uiElement.summery, trend: uiElement.trend, isHighlighted: uiElement.highlighted)
        
        
        switch uiElement.imageStrategy {
        case .coverImage:
            locationsImage.isHidden = true
            tagImage.isHidden = false
            tagImage.display(images: uiElement.images)
            
        case .infestationMap:
            locationsImage.display(images: uiElement.coverImage)
            locationsImage.isHidden = false
            tagImage.isHidden = true
            
        case .map:
            locationsImage.display(images: uiElement.coverImage)
            locationsImage.isHidden = false
            tagImage.isHidden = true
            
        case .none:
            locationsImage.isHidden = true
            tagImage.isHidden = true
        }
    }
    
    private func handleTrend(summery: String?, trend : Int?, isHighlighted: Bool) {
        
        trendStack.isHidden = trend == nil || trend == .zero
        summeryText.isHidden = summery == nil
        summeryText.text = summery
        trendImage.image = trend ?? .zero > .zero ? R.image.arrowUp() : R.image.arrowDown()
        trendValue.text = "\(abs(trend ?? .zero))%"
        trendContainerStack.isHidden = trend == nil && summery == nil || isHighlighted

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagImage.drawTags(tags: uiElement.tags, color: uiElement.tagColor)
        locationsImage.drawLocations(locations: uiElement.locations)
    }
    
}
