//
//  OverviewInformationView.swift
//  Openfield
//
//  Created by dave bitton on 09/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import RxSwift
import UIKit

class OverviewInformationView: UIView {
    @IBOutlet var mainTitle: BodyBoldPrimary!
    @IBOutlet var infoTableView: UITableView!
    @IBOutlet var actionBtn: UIButton!

    struct InfoDataElement {
        let title: String
        let subtitle: String
        var subtitleStyles: [(font: UIFont, substring: String)]? = nil
    }

    private var mainView: UIView!
    private var infoData = [InfoDataElement]()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        mainView = UINib(resource: R.nib.overviewInformationView).instantiate(withOwner: self, options: nil).first as? UIView
        mainView.frame = bounds
        addSubview(mainView)
        setupUI()
        infoTableView.register(UINib(resource: R.nib.overviewInfoTableViewCell), forCellReuseIdentifier: R.reuseIdentifier.overviewInfoTableViewCell.identifier)
        infoTableView.dataSource = self
    }

    private func setupUI() {
        mainTitle.font = R.font.avertaBold(size: 24)
        actionBtn.setTitle(R.string.localizable.imageLayerDataThanksGotIt(), for: .normal)
        actionBtn.setTitleColor(R.color.primary(), for: .normal)
        actionBtn.titleLabel?.font = R.font.avertaRegular(size: 16)
    }

    func bind(header: String, infoData: [InfoDataElement]) {
        mainTitle.text = header
        self.infoData = infoData
        infoTableView.reloadData()
    }

    @IBAction func btnAction(_: Any) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

extension OverviewInformationView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return infoData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.overviewInfoTableViewCell.identifier, for: indexPath) as! OverviewInfoTableViewCell
        cell.bind(info: infoData[indexPath.row])
        return cell
    }
}
