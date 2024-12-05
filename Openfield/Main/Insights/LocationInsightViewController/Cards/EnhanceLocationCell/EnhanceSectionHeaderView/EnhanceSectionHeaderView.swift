//
//  EnhanceSectionHeaderView.swift
//  Openfield
//
//  Created by amir avisar on 04/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import UIKit

class EnhanceSectionHeaderView: UIView {
    // MARK: - Static members

    static let height: CGFloat = 34

    // MARK: - Outlets

    @IBOutlet var titleLabel: BodyBoldPrimary!
    @IBOutlet var subtitleLabel: BodyBoldPrimary!
    @IBOutlet private var contentView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var infoView: UIImageView!

    let disposeBag = DisposeBag()

    var infoClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?> = PublishSubject()

    // MARK: - required

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - UI

    private func setup() {
        UINib(resource:
            R.nib.enhanceSectionHeaderView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        infoView.rx.tapGesture().when(.recognized).subscribe { [weak self] element in
            guard let self = self else { return }
            guard let element = element.element else { return }
            self.infoClick.onNext(element)
        }.disposed(by: disposeBag)
        forQA()
    }

    private func forQA() {
        accessibilityIdentifier = "enhance_header"
        titleLabel.accessibilityIdentifier = "title"
        subtitleLabel.accessibilityIdentifier = "subtitle"
        infoView.accessibilityIdentifier = "info_button"
    }

    // MARK: - Bind

    func bind(title: String, summery: String, onClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>) {
        titleLabel.text = title
        infoClick = onClick
        if summery.isEmpty {
            subtitleLabel.text = nil
            infoView.isHidden = false
            return
        }
        infoView.isHidden = true
        subtitleLabel.text = summery
    }
}

extension EnhanceSectionHeaderView {
    static func instanceFromNib(rect: CGRect) -> EnhanceSectionHeaderView {
        return EnhanceSectionHeaderView(frame: rect)
    }
}
