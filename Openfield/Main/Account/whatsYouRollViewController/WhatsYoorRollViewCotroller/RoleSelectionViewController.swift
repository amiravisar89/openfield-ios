//
//  RoleSelectionViewController.swift
//  Openfield
//
//  Created by amir avisar on 30/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics
import ReactorKit
import Resolver
import RxSwift
import UIKit

protocol RoleSelectionDelegate: AnyObject {
    func roleSelected(role: UserRole)
}

class RoleSelectionViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var mainBtn: ButtonValleyBrandBoldWhite!
    @IBOutlet var rolesTableView: UITableView!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var container: UIView!
    @IBOutlet var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet var bottomCotainerConstrait: NSLayoutConstraint!
    @IBOutlet var xBtn: UIButton!
    @IBOutlet var mainCloseBtn: UIButton!

    // MARK: - Members

    var disposeBag = DisposeBag()
    let userUseCase : UserStreamUsecase = Resolver.resolve()
    let translationService: TranslationService = Resolver.resolve()
    let getUserRolesUseCase: GetUserRolesUseCase = Resolver.resolve()
    var type: RolePopUpType!
    var didKeyboardOpen = false
    var otherText: String?

    // MARK: - delegate

    weak var delegate: RoleSelectionDelegate?

    var allRoles: [RoleViewModel] = []

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.rolePopUp, .openRolePopUp))
        topContainerConstraint.constant = UIScreen.main.bounds.height
        view.layoutIfNeeded()
        registerToKeyboardNotifications()
        initView()
        setStatusBarColor(color: .clear)
        setUpText()
        setUpTableView()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topContainerConstraint.constant = 100
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    func handleMainBtn() {
        let selectedArray = allRoles.filter { $0.isSelected }
        selectedArray.count > 0 ? enableBtn() : disableBtn()
        selectedArray.count > 0 ? enableBtn() : disableBtn()
    }

    func bind() {
        userUseCase.userStream().compactMap { $0.settings }.observeOn(MainScheduler.instance).map { userSettings -> ([RoleViewModel], UserRole?) in
            let roles = self.getUserRolesUseCase.roles().map { RoleViewModel(title: self.translationService.localizedString(localizedString: $0.i18n_role, defaultValue: $0.id), isSelected: (userSettings.userRole?.rolesIds?.contains($0.id)) ?? false, roleId: $0.id, i18n_role: $0.i18n_role) }
            return (roles, userSettings.userRole)
        }.subscribe { [weak self] roles, userRole in
            guard let self = self else { return }
            self.allRoles = roles
            self.handleMainBtn()
            self.otherText = userRole?.otherText
            self.rolesTableView.reloadData()
        }.disposed(by: disposeBag)

        mainBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            let rolesSelected = self.allRoles.filter { $0.isSelected }
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.rolePopUp, .roleSelection, [EventParamKey.rolesList: rolesSelected.map { $0.roleId }.joined(separator: ",")]))
            self.otherText = rolesSelected.first(where: { $0.roleId == UserRoleConfiguration.OtherRoleId }) == nil ? nil : self.otherText
            self.delegate?.roleSelected(role: UserRole(rolesIds: rolesSelected.map { $0.roleId }, otherText: self.otherText))
            self.dismissWithAnim()
        }.disposed(by: disposeBag)

        xBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.dismissWithAnim()
        }.disposed(by: disposeBag)

        mainCloseBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.dismissWithAnim()
        }.disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func dismissWithAnim() {
        topContainerConstraint.constant = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    private func disableBtn() {
        mainBtn.isEnabled = false
        mainBtn.alpha = 0.4
    }

    private func enableBtn() {
        mainBtn.isEnabled = true
        mainBtn.alpha = 1
    }

    private func initView() {
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        mainBtn.backgroundColor = R.color.valleyBrand()
    }

    private func setUpText() {
        switch type {
        case .popUp1:
            subTitle.text = R.string.localizable.roleYouCanAlwaysChangeYourRole()
            mainCloseBtn.isHidden = true
            xBtn.isHidden = true
            mainTitle.text = R.string.localizable.roleBeforeWeContinueWhatIsYourRole()
            mainBtn.titleString = R.string.localizable.submit()
        case .popUp2:
            subTitle.text = R.string.localizable.roleSelectMoreThanOne()
            mainCloseBtn.isHidden = false
            xBtn.isHidden = false
            mainBtn.titleString = R.string.localizable.done()
            mainTitle.text = R.string.localizable.roleWhatIsYourRole()
        default:
            break
        }
    }
}

// MARK: - Keyboard

extension RoleSelectionViewController {
    func registerToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, didKeyboardOpen == false {
            didKeyboardOpen = true
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomCotainerConstrait.constant += keyboardHeight
            topContainerConstraint.constant -= keyboardHeight
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_: Notification) {
        didKeyboardOpen = false
        bottomCotainerConstrait.constant = 0
        topContainerConstraint.constant = 100
        view.layoutIfNeeded()
    }
}

extension RoleSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    private func setUpTableView() {
        rolesTableView.register(UINib(nibName: R.nib.roleCell.identifier, bundle: nil), forCellReuseIdentifier: R.nib.roleCell.identifier)
        rolesTableView.delegate = self
        rolesTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        allRoles[indexPath.row].isSelected = !allRoles[indexPath.row].isSelected
        handleMainBtn()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RoleCell = tableView.dequeueReusableCell(withIdentifier: R.nib.roleCell.identifier, for: indexPath) as! RoleCell
        cell.delegate = self
        cell.initCell(role: allRoles[indexPath.row], otherText: otherText)
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return allRoles.count
    }
}

extension RoleSelectionViewController: RoleCellDelegate {
    func otherIsTyping(text: String?) {
        guard let text = text else {
            otherText = nil
            return
        }
        otherText = text.isEmpty ? nil : text
    }
}

extension RoleSelectionViewController {
    class func instantiate(type: RolePopUpType) -> RoleSelectionViewController {
        let vc = R.storyboard.roleSelectionViewController.roleSelectionViewController()!
        vc.type = type
        return vc
    }
}

enum RolePopUpType {
    case popUp1 // after the carusel, first use user
    case popUp2 // from settings || already login user
}
