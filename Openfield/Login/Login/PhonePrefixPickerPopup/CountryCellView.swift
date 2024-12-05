//
//  CountryCellView.swift
//  Openfield
//
//  Created by Daniel Kochavi on 10/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class CountryCellView: UIView {
    let countryNameLabel = BodyRegularPrimary()
    let countryPrefixLabel = BodyRegularSecondary()
    let container = UIView()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    public func bind(country: CountryCellData) {
        container.accessibilityIdentifier = "CountryCellContainer_\(country.name.replacingOccurrences(of: " ", with: "_"))" // QA
        countryNameLabel.text = country.name
        countryPrefixLabel.text = country.prefix
    }

    private func setupUI() {
        backgroundColor = .clear
        container.backgroundColor = .clear
        addSubview(container)
        container.addSubview(countryNameLabel)
        container.addSubview(countryPrefixLabel)

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        countryNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        countryPrefixLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
