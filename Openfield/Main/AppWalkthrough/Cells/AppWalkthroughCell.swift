//
//  AppWalkthroughCell.swift
//  Openfield
//
//  Created by Omer Cohen on 2/23/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FSPagerView
import Resolver
import RxGesture
import RxSwift
import UIKit

struct AppWalkthroughCellInput {
    let layerImage: UIImage
    let layerTitle: String
    let layerContent: String
    let buttonTitle: String
    let isEnabled: Bool
    let showError: Bool
}

class AppWalkthroughCell: FSPagerViewCell {
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var layerImage: UIImageView!
    @IBOutlet weak var layerTitle: UILabel!
    @IBOutlet weak var layerContent: UILabel!
    @IBOutlet weak var button: ButtonValleyBrandBoldWhite!
    @IBOutlet weak var contractStackView: UIStackView!
    @IBOutlet weak var contractAttributeTextView: SubHeadlineTextViewRegularSecondary!
    @IBOutlet weak var contractErrorLabel: ErrorSublineRegularRed!
    @IBOutlet weak var signToggle: AppCheckBox!
    @IBOutlet weak var emptyBtn: UIView!

    var disposeBag = DisposeBag()
    let animationProvider: AnimationProvider = Resolver.resolve()

    let contractSelected = PublishSubject<ContractType>()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = bounds
        contentView.layer.shadowRadius = 0
        contractErrorLabel.text = R.string.localizable.contractTermOfSseCheckboxError()
        contractAttributeTextView.textContainer.maximumNumberOfLines = 0
    }

    func setAppWalkthroughCell(appWalkthroughCellInput: AppWalkthroughCellInput, index: Int) {
        layerImage.image = appWalkthroughCellInput.layerImage
        layerTitle.text = appWalkthroughCellInput.layerTitle
        layerContent.text = appWalkthroughCellInput.layerContent
        button.titleString = appWalkthroughCellInput.buttonTitle
        contractStackView.isHidden = index != .zero
        button.isEnabled = appWalkthroughCellInput.isEnabled
        handleError(showError: appWalkthroughCellInput.showError)
        emptyBtn.isHidden = appWalkthroughCellInput.isEnabled
        signToggle.isError = appWalkthroughCellInput.showError
        setupQAIds(index: index)
        setupContractAttributedText()
        imageWidthConstraint?.isActive = index != .zero
    }

    func setupContractAttributedText() {
        contractAttributeTextView.text = R.string.localizable.contractTermOfUse()
        contractAttributeTextView.delegate = self
        let attributes = [TextViewAttribute(text: R.string.localizable.contractTouLinkablePart(),
                                            color: R.color.valleyBrand()!,
                                            type: ContractType.terms.rawValue, queryParam: URLParam.contractType.rawValue),
                          TextViewAttribute(text: R.string.localizable.contractPpLinkablePart(),
                                            color: R.color.valleyBrand()!,
                                            type: ContractType.privacy.rawValue, queryParam: URLParam.contractType.rawValue)]
        contractAttributeTextView.setAttributes(attributes: attributes)
    }

    private func handleError(showError: Bool) {
        animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
            guard let self = self else { return }
            self.contractErrorLabel.alpha = showError ? 1 : .zero
        }.observeOn(MainScheduler.instance).subscribe().disposed(by: disposeBag)
    }

    private func setupQAIds(index: Int) {
        layerImage.accessibilityIdentifier = "AppWalkthrew_mainImage_index_\(index)"
        layerTitle.accessibilityIdentifier = "AppWalkthrew_Title_index_\(index)"
        layerContent.accessibilityIdentifier = "AppWalkthrew_Content_index_\(index)"
        button.accessibilityIdentifier = "lets_get_started_button"
        contractErrorLabel.accessibilityIdentifier = "contract_error"
        contractAttributeTextView.accessibilityIdentifier = "contract_title"
    }
}

extension AppWalkthroughCell: UITextViewDelegate {
    func textView(_: UITextView, shouldInteractWith URL: URL, in _: NSRange, interaction _: UITextItemInteraction) -> Bool {
        guard let params = URL.queryParameters,
              let contractType = params[URLParam.contractType.rawValue],
              let contract = ContractType(rawValue: contractType) else { return false }

        switch contract {
        case .terms:
            contractSelected.onNext(contract)
        case .privacy:
            contractSelected.onNext(contract)
        case .changes:
            contractSelected.onNext(contract)
        case .support:
            break
        }
        return false
    }
}
