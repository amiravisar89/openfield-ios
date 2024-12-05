//
//  GuideCustomView.swift
//  Openfield
//
//  Created by Amitai Efrati on 19/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import UIKit

@IBDesignable
class GuideCustomView: UIView {
  @IBOutlet var closeButton: UIImageView!
  @IBOutlet var contentView: UIView!
  @IBOutlet var pinchLabel: UILabel!
  @IBOutlet var tapOnCellLabel: UILabel!
  @IBOutlet var changeDatesLabel: UILabel!

  let disposeBag = DisposeBag()
  let cornerRadius = 16.0

  var closeButtonClick: PublishSubject<Void> = PublishSubject()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    UINib(resource: R.nib.guideCustomView).instantiate(withOwner: self, options: nil)
    addSubview(contentView)
    contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
    contentView.viewCornerRadius = cornerRadius
    pinchLabel.text = R.string.localizable.virtualScoutingGuidePinchMapToZoom()
    tapOnCellLabel.text = R.string.localizable.virtualScoutingGuideTapOnCell()
    changeDatesLabel.text = R.string.localizable.virtualScoutingGuideChangeDates()
    contentView.accessibilityIdentifier = "guide"
    bind()
  }

  private func bind() {
    closeButton.rx.tapGesture().when(.recognized)
      .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.closeButtonClick.onNext(())
      }).disposed(by: disposeBag)
  }
}
