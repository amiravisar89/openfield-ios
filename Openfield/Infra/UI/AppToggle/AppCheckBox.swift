//
//  AppCheckBox.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import Resolver
import RxSwift
import SnapKit
import UIKit

@IBDesignable
class AppCheckBox: UIView {
    let disposeBag = DisposeBag()
    @IBOutlet var contentView: UIView!
    @IBOutlet var vImage: UIImageView!
    @IBOutlet var containerView: UIView!

    let cornerRadius = 4.0
    let borderWidth = 1.0
    let checkboxAccesabiltie = "app_check_box_"

    var isSelected: PublishSubject<Bool> = PublishSubject()
    var isSelectedValue: Bool = false

    var isError: Bool = false {
        didSet {
            self.contentView.viewBorderColor = isError ? R.color.error()! : R.color.toggleUnselected()!
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        UINib(resource: R.nib.appCheckBox).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        contentView.viewCornerRadius = cornerRadius
        contentView.viewBorderWidth = borderWidth
        contentView.viewBorderColor = R.color.toggleUnselected()!
        bind()
        accessibilityIdentifier = "\(checkboxAccesabiltie)unselected"
    }

    private func bind() {
        rx.tapGesture().when(.recognized)
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isSelected.onNext(!self.isSelectedValue)
                self.isSelectedValue = !self.isSelectedValue
                self.animateClick()
            }).disposed(by: disposeBag)

        isSelected.distinctUntilChanged().observeOn(MainScheduler.instance).bind { [weak self] isSelected in
            guard let self = self else { return }
            self.containerView.backgroundColor = isSelected ? R.color.selectedBackGround()! : R.color.white()
            self.vImage.isHidden = isSelected ? false : true
            self.accessibilityIdentifier = "\(self.checkboxAccesabiltie)\(isSelected ? "selected" : "unselected")"
        }.disposed(by: disposeBag)
    }
}

enum AppToggleState {
    case empty
    case error
    case selected
}
