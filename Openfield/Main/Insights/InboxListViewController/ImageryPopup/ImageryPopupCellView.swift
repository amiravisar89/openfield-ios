//
//  ImageryPopupCellView.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import RxSwift
import SwiftDate
import UIKit

class ImageryPopupCellView: UITableViewCell {
    @IBOutlet private var imageryImageView: UIImageView!
    @IBOutlet private var imageryTitle: UILabel!
    @IBOutlet private var dateLabel: CaptionRegularSecondary!

    private var languageService: LanguageService = Resolver.resolve()
    private let dateProvider: DateProvider = Resolver.resolve()
    private var local: Locale = LanguageService.defaultLanguage.locale
    var disposeBag: DisposeBag = .init()
    static let cellHeight: CGFloat = 57

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        languageService.currentLanguage.bind { self.local = $0.locale }
            .disposed(by: disposeBag)
    }

    public func bind(to imageryImage: ImageryImage) {
        let strUrl = imageryImage.url.replacingOccurrences(of: "s3://prospera-thumbs-us", with: "https://thumbs-us.o.prospera.ag") // TODO-Daniel: Remove this hack

        if let url = URL(string: strUrl) {
            imageryImageView.kf.setImage(with: url, placeholder: R.image.imageThumbnailPlaceHolder()!, options: [.transition(.fade(1))], completionHandler: { result in
                switch result {
                case let .success(value):
                    self.imageryImageView.image = value.image
                case let .failure(error):
                    self.imageryImageView.image = R.image.imageThumbnailPlaceHolder()!
                    log.error("KingFisher error: \(error)")
                }
            })
        }

        dateLabel.text = dateProvider.format(date: imageryImage.date, region: imageryImage.region, format: .shortDayName)
        imageryTitle.text = imageryImage.field.name.capitalize()
    }

    override func setHighlighted(_ highlighted: Bool, animated _: Bool) {
        if highlighted {
            backgroundColor = R.color.highLightedCell()!
        } else {
            backgroundColor = .white
        }
    }
}
