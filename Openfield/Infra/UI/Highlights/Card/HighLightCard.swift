//
//  AppButtomLine.swift
//  LottoMatic
//
//  Created by amir avisar on 29/01/2022.
//

import Foundation
import UIKit

@IBDesignable
class HighlightCard: BaseView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var navigateBtn: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit(){
        view = loadFromNib(nibName: R.nib.highLightCard.name)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = self.bounds
        view.viewCornerRadius = 16
        view.viewBorderWidth = 1
        view.viewBorderColor = R.color.grey3()!
        addSubview(view)
        self.backgroundColor = R.color.screenBg()!
        view.backgroundColor = R.color.white()!
        navigateBtn.image = R.image.highlightBtn()
    }
    
    public func initCard(card : HighlightCardData) {
        titleLabel.text = card.field
        subjectLabel.text = card.insight
        typeLabel.text = card.insightType
        dateLabel.text = card.date
        mainImage.kf.setImage(with: URL(string: card.imageUrl), placeholder: R.image.imageThumbnailPlaceHolder()!, options: [.transition(.fade(1))])
        initQA(card: card)
    }
    
    func initQA(card : HighlightCardData){
        titleLabel.accessibilityIdentifier = "card_title_\(card.insightUID)"
        subjectLabel.accessibilityIdentifier = "card_subject_\(card.insightUID)"
        typeLabel.accessibilityIdentifier = "card_type_\(card.insightUID)"
        dateLabel.accessibilityIdentifier = "card_date_\(card.insightUID)"
    }
    
}
