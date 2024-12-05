//
//  AnalysisTabs.swift
//  Openfield
//
//  Created by Daniel Kochavi on 18/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

@IBDesignable class AnalysisTabs: UIControl {
    @IBOutlet private var contentView: UIView!
    @IBOutlet fileprivate var layerButton: AnalysisTabItem!
    @IBOutlet fileprivate var dateButton: AnalysisTabItem!
    @IBOutlet fileprivate var insightButton: AnalysisTabItem!
    @IBOutlet var bufferRight: UIView!
    @IBOutlet var topSeparator: UIView!
    @IBOutlet var bufferLeft: UIView!
    @IBOutlet var bottomSeparator: UIView!
    let disposeBag = DisposeBag()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public func toggleCompare(isCompare: Bool) {
        layer.shadowColor = isCompare ? UIColor.clear.cgColor : UIColor.black.cgColor
        layerButton.toggleCompare(isCompare: isCompare)
        dateButton.toggleCompare(isCompare: isCompare)
        insightButton.toggleCompare(isCompare: isCompare)
    }

    private func setup() {
        setupView()
        setupStaticData()
        setupQA()
        setupStaticColor()
    }

    private func setupStaticColor() {
        bufferLeft.backgroundColor = R.color.lightGrey()
        bufferRight.backgroundColor = R.color.lightGrey()
        topSeparator.backgroundColor = R.color.lightGrey()
        bottomSeparator.backgroundColor = R.color.lightGrey()
    }

    private func setupView() {
        UINib(resource: R.nib.analysisTabs).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
    }

    private func setupStaticData() {
        layerButton.title(tabTitle: R.string.localizable.analysisAnalysisImageType())
        layerButton.image(image: R.image.analysis_layers()!)
        layerButton.disabledImage(image: R.image.analysis_layers_off()!)

        dateButton.title(tabTitle: R.string.localizable.analysisAnalysisImageDate())
        dateButton.image(image: R.image.analysis_date()!)
        dateButton.disabledImage(image: R.image.analysis_date_off()!)

        insightButton.title(tabTitle: R.string.localizable.analysisAnalysisInsights())
        insightButton.image(image: R.image.analysis_detection()!)
        insightButton.disabledImage(image: R.image.analysis_detection_off()!)
    }

    private func setupQA() {
        insightButton.accessibilityIdentifier = "insights_button"
        insightButton.accessibilityTraits = [.button]
        dateButton.accessibilityIdentifier = "date_button"
        dateButton.accessibilityTraits = [.button]
        layerButton.accessibilityIdentifier = "layers_button"
        layerButton.accessibilityTraits = [.button]
    }

    fileprivate func updateLayer(with layer: String?) {
        layerButton.content(tabContent: layer, accesabilty: "layer_picker")
    }

    fileprivate func updateDate(with date: String?) {
        dateButton.content(tabContent: date, accesabilty: "date_picker")
    }

    fileprivate func updateInsights(with insights: String?) {
        insightButton.content(tabContent: insights, accesabilty: "insight_picker")
    }
}

extension AnalysisTabs {
    static func instanceFromNib() -> AnalysisTabs {
        return AnalysisTabs(frame: CGRect.zero)
    }
}

extension Reactive where Base: AnalysisTabs {
    var tapLayers: Observable<UITapGestureRecognizer> {
        return base.layerButton.rx.tapGesture()
            .when(.recognized)
            .filter { _ in self.base.layerButton.canClick }
    }

    var tapDate: Observable<UITapGestureRecognizer> {
        return base.dateButton.rx.tapGesture()
            .when(.recognized)
            .filter { _ in self.base.dateButton.canClick }
    }

    var tapInsights: Observable<UITapGestureRecognizer> {
        return base.insightButton.rx.tapGesture()
            .when(.recognized)
            .filter { _ in self.base.insightButton.canClick }
    }

    var layer: Binder<String?> {
        return Binder(base) { view, content in
            view.updateLayer(with: content)
        }
    }

    var date: Binder<String?> {
        return Binder(base) { view, content in
            view.updateDate(with: content)
        }
    }

    var insights: Binder<String?> {
        return Binder(base) { view, content in
            view.updateInsights(with: content)
        }
    }
}
