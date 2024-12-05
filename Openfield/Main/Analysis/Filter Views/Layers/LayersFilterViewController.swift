//
//  LayersFilterViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 19/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import CollectionKit
import PullUpController
import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class LayerFilterViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = .init()

    typealias Reactor = AnalysisReactor

    @IBOutlet var layerCollection: CollectionView!
    @IBOutlet var closeBtn: SGButton!
    @IBOutlet var viewBackground: UIView!

    let dataSource = ArrayDataSource(data: [LayerCell]())

    static var viewSize = CGSize(width: UIScreen.main.bounds.width, height: 202)

    override func viewDidLoad() {
        setupStaticTexts()
        setupStaticColor()
        setupAccessibility()
    }

    private func setupAccessibility() {
        closeBtn.accessibilityIdentifier = "layer_close"
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.white()
    }

    private func setupStaticTexts() {
        closeBtn.titleString = R.string.localizable.closeButton()
    }

    private func setupCollection(reactor: AnalysisReactor) {
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: { (view: AnalysisLayerCell, data: LayerCell, _: Int) in
                view.bind(to: data)
                view.accessibilityIdentifier = "layer_cell"
                view.accessibilityTraits = [.button]
            },
            sizeSource: AutoLayoutSizeSource(dummyView: AnalysisLayerCell.self,
                                             viewUpdater: { _, _, _ in }),
            tapHandler: { [weak self] context in
                guard let self = self else { return }
                Observable.just(context.data)
                    .filter { $0.isEnabled }
                    .map { Reactor.Action.selectedLayer(layerCell: $0) }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            }
        )

        let layout = RowLayout(spacing: 10, justifyContent: .center)
        layout.alignItems = .center
        provider.layout = layout
        layerCollection.provider = provider
    }

    func bind(reactor: AnalysisReactor) {
        setupCollection(reactor: reactor)

        closeBtn.rx.tapGesture()
            .when(.recognized)
            .do(onNext: { _ in EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.layerSelection, "layers_selection_close")) })
            .subscribe(onNext: { [weak self] _ in
                self?.hideMySelf()
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.layers }
            .subscribe(onNext: { [weak self] data in
                self?.dataSource.data = data
                self?.layerCollection.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func hideMySelf() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.frame.origin.y = UIScreen.main.bounds.height
            }
        }
    }
}

extension LayerFilterViewController {
    class func instantiate(with reactor: AnalysisReactor?) -> LayerFilterViewController {
        let vc = R.storyboard.layersFilterViewController.layerFilterViewController()!
        vc.reactor = reactor
        return vc
    }
}
