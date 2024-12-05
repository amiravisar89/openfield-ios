//
//  NotificationCell.swift
//  Openfield
//
//  Created by Eyal Prospera on 17/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import BetterSegmentedControl
import UIKit

protocol NotificationCellDelegate: AnyObject {
    func notificationTypeChanged(value: String)
}

class NotificationCell: UIControl {
    @IBOutlet var notificationSwitch: UISwitch!
    @IBOutlet var notificationSwitchButton: UIView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet var pushSmsToggle: BetterSegmentedControl!
    @IBOutlet var smsToggleMask: UIView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var notificationsLabel: BodyBoldPrimary!
    @IBOutlet var subtitle: UILabel!

    public weak var delegate: NotificationCellDelegate?
    public var notificationsEnabled: Bool = true {
        didSet {
            updateUI()
        }
    }

    public var phoneNumber: String! {
        didSet {
            updateUI()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        setupView()
        setupSmsPushToggleView()
        setupStaticText()
        setupQA()
        setupStaticColor()
    }

    private func setupQA() {
        smsToggleMask.accessibilityIdentifier = "NotificationCellTypeToggle"
        notificationSwitch.accessibilityIdentifier = "notifications_switch"
        pushSmsToggle.accessibilityIdentifier = "push_sms_toggle"
    }

    private func setupStaticColor() {
        notificationSwitch.onTintColor = R.color.valleyBrand()
    }

    private func setupStaticText() {
        notificationsLabel.text = R.string.localizable.accountNotifications()
        subtitle.text = R.string.localizable.accountSelectNotificationType()
    }

    private func setupView() {
        UINib(resource:
            R.nib.notificationCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true

        notificationSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }

    private func setupSmsPushToggleView() {
        pushSmsToggle.segments = LabelSegment.segments(withTitles: [R.string.localizable.accountPush(), R.string.localizable.accountSms()],
                                                       normalFont: SubHeadline.regFont,
                                                       normalTextColor: R.color.secondary(),
                                                       selectedFont: SubHeadline.regFont,
                                                       selectedTextColor: R.color.white())

        pushSmsToggle.indicatorViewBackgroundColor = R.color.valleyBrand()
        pushSmsToggle.indicatorViewInset = 0

        pushSmsToggle.layer.borderWidth = 1
        pushSmsToggle.layer.borderColor = R.color.lightGrey()!.cgColor

        smsToggleMask.backgroundColor = UIColor(white: 1.0, alpha: 0.70)

        pushSmsToggle.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
    }

    public func setToggleIndex(_ index: Int) {
        let currentDelegate = delegate
        delegate = nil
        pushSmsToggle.setIndex(index, animated: false)
        delegate = currentDelegate
    }

    @objc func toggleValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            delegate?.notificationTypeChanged(value: R.string.localizable.accountPush())
        } else {
            delegate?.notificationTypeChanged(value: R.string.localizable.accountSms())
        }
    }

    private func updateUI() {
        smsToggleMask.isHidden = notificationsEnabled
        if notificationsEnabled {
            if (pushSmsToggle.index) == 0 {
                infoLabel.text = R.string.localizable.accountSentBetweenPush()
            } else {
                infoLabel.text = String(format: "• %@ \n• %@ ", R.string.localizable.accountSentBetweenSMS(), R.string.localizable.accountSendingSMSTo_iOS(phoneNumber))
            }
            infoLabel.textColor = R.color.secondary()
        } else {
            infoLabel.text = R.string.localizable.accountNotificationDisabled()
            infoLabel.textColor = R.color.red()
        }
    }
}

