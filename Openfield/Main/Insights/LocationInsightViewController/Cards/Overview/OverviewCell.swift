//
//  OverviewCell.swift
//  Openfield
//
//  Created by Itay Kaplan on 03/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import FSPagerView
import RxCocoa
import RxSwift
import UIKit

class OverviewCell: FSPagerViewCell {
    @IBOutlet var overviewTable: UITableView!
    @IBOutlet var title: BodyBoldPrimary!
    @IBOutlet var subTitle: BodyLightSecondary!
    @IBOutlet var infoView: UIView!
    var disposeBag: DisposeBag = .init()
    var infoClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?> = PublishSubject()

    override func awakeFromNib() {
        super.awakeFromNib()
        overviewTable?.dataSource = self
        overviewTable?.delegate = self
        initQA()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(card: OverviewCard, onClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>) {
        infoClick = onClick
        title?.text = card.title
        subTitle?.text = card.subtitle
        initQA()
        bind()
    }

    func bind() {
        infoView.rx.tapGesture().when(.recognized).subscribe { [weak self] element in
            guard let self = self else { return }
            guard let element = element.element else { return }
            self.infoClick.onNext(element)
        }.disposed(by: disposeBag)
    }

    func initQA() {
        title?.accessibilityIdentifier = "title_label"
        subTitle?.accessibilityIdentifier = "subtitle_label"
    }
}

extension OverviewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { return 0 }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {}

    func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell { return UITableViewCell() }
}
