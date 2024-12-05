//
//  RoleCell.swift
//  Openfield
//
//  Created by amir avisar on 30/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Resolver
import RxCocoa
import RxSwift
import UIKit

protocol RoleCellDelegate: AnyObject {
    func otherIsTyping(text: String?)
}

class RoleCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var vImage: UIImageView!
    @IBOutlet var vImageContainer: UIView!

    weak var delegate: RoleCellDelegate?
    let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStaticTexts()
    }

    func initCell(role: RoleViewModel, otherText: String?) {
        setup(role: role, otherText: otherText)
        bind()
    }

    func setup(role: RoleViewModel, otherText: String?) {
        vImage.image = role.isSelected ? R.image.blueV() : nil
        let isOther = role.roleId == UserRoleConfiguration.OtherRoleId

        mainTitle.text = role.title

        vImageContainer.backgroundColor = role.isSelected ? R.color.selectedBackGround()! : .clear
        vImageContainer.viewBorderColor = role.isSelected ? R.color.valleyBrand()! : R.color.lightGrey()!
        mainTitle.textColor = role.isSelected ? R.color.valleyBrand() : R.color.primary()
        mainTitle.isHidden = (role.isSelected && isOther)

        textField.isHidden = !(role.isSelected && isOther)
        textField.textColor = (role.isSelected && isOther) ? R.color.valleyBrand() : R.color.primary()

        if role.isSelected && isOther {
            textField.text = otherText == nil || otherText == "" ? R.string.localizable.roleOther() : otherText
        }
    }

    func setupStaticTexts() {
        textField.placeholder = R.string.localizable.accountInsertRole()
    }

    func bind() {
        textField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe { [weak self] _ in
                self?.delegate?.otherIsTyping(text: self?.textField.text)
            }.disposed(by: disposeBag)

        textField.rx.controlEvent([.editingDidEndOnExit])
            .asObservable().subscribe { [weak self] _ in
                self?.endEditing(true)
            }.disposed(by: disposeBag)
    }
}
