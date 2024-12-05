//
//  FieldsSeachBar.swift
//  LottoMatic
//
//  Created by amir avisar on 06/03/2022.
//

import Foundation
import Resolver
import RxCocoa
import RxGesture
import RxSwift
import UIKit

@IBDesignable
class FieldSearchBar: BaseView {
    let disposeBag = DisposeBag()

    @IBOutlet var view: UIView!
    @IBOutlet var seachImage: UIImageView!
    @IBOutlet var searchTF: TextFieldTitle2RegularWhite!
    @IBOutlet var clearIcon: UIImageView!
    @IBOutlet weak var clearBtn: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        view = loadFromNib(nibName: R.nib.fieldsSeachBar.name)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
        view.viewCornerRadius = 10
        seachImage.setImage(R.image.headerSearchIcon()!)
        initStaticColors()
        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.viewCornerRadius = view.frame.height / 2
    }

    func bind() {
        searchTF.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clearIcon.isHidden = (self.searchTF.text?.isEmpty ?? true)
            }
            .disposed(by: disposeBag)

        clearBtn.rx.tapGesture().when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.searchTF.text = ""
                self.searchTF.resignFirstResponder()
                self.clearIcon.isHidden = true
            }
            .disposed(by: disposeBag)
    }

    func initStaticColors() {
        backgroundColor = .clear
        view.backgroundColor = R.color.searchBarColor()
    }
}
