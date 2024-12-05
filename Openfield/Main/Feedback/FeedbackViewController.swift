//
//  FeedbackViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 29/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import ReactorKit
import RxSwift
import TagListView
import UIKit

final class FeedbackViewController: UIViewController, StoryboardView {
    typealias Reactor = InsightViewReactor

    static let analyticName = "feedback"

    var disposeBag: DisposeBag = .init()

    weak var measureDelegate: ViewControllerMeasureDelegate?

    @IBOutlet var textViewPlaceHolder: UILabel!
    @IBOutlet var answersTags: TagListView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var thankYouLabel: UILabel!
    @IBOutlet var closeBtn: SGButton!
    @IBOutlet var otherView: UIView!
    @IBOutlet var otherTextView: UITextView!
    @IBOutlet var otherSubmitBtn: UIButton!
    @IBOutlet var otherCancelBtn: UIButton!

    @IBOutlet var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        otherTextView.delegate = self
        setupStaticText()
        setupAnswersTagsView()
        generateAccessibilityIdentifiers()
    }

    func setupStaticText() {
        textViewPlaceHolder.text = R.string.localizable.feedbackReasonHowWeCanDoBetter()
        titleLabel.text = R.string.localizable.insightHelpImprove()
        subtitleLabel.text = R.string.localizable.insightWhyNotUseful()
        thankYouLabel.text = R.string.localizable.insightThanksFeedback()
        thankYouLabel.alpha = 0
        closeBtn.titleString = R.string.localizable.closeButton()
        otherSubmitBtn.setTitle(R.string.localizable.submit(), for: .normal)
        otherCancelBtn.setTitle(R.string.localizable.cancel(), for: .normal)
        otherSubmitBtn.backgroundColor = R.color.valleyBrand()
    }

    func setupAnswersTagsView() {
        backgroundView.backgroundColor = R.color.screenBg()!
        answersTags.tagBackgroundColor = R.color.white()! // Needs to be first statement in setup
        answersTags.tagSelectedBackgroundColor = R.color.valleyBrand()
        answersTags.textColor = R.color.primary()!
        answersTags.selectedTextColor = R.color.white()!
        answersTags.borderColor = R.color.lightGrey()
        answersTags.borderWidth = 1
        answersTags.cornerRadius = 20
        answersTags.paddingX = 18
        answersTags.paddingY = 12
        answersTags.alignment = .center
        answersTags.marginX = 8
        answersTags.marginY = 10
        answersTags.textFont = BodyRegular.regFont!
        answersTags.delegate = self
        answersTags.isAccessibilityElement = false // QA
    }

    func showOtherTextView() {
        UIView.animate(withDuration: 0.3) {
            self.otherView.alpha = 1
            self.view.layoutIfNeeded()
        }
        otherTextView.becomeFirstResponder()
    }

    func hideOtherTextView() {
        UIView.animate(withDuration: 0.3) {
            self.otherView.alpha = 0
            self.view.layoutIfNeeded()
        }
        view.endEditing(true)
    }

    func closeFeedbackEffect() {
        dismiss(animated: true)
    }

    func bind(reactor: InsightViewReactor) {
        // Action

        closeBtn.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.closeFeedback(closeFeedbackEffect: self.closeFeedbackEffect) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor
            .state
            .map { $0.feedbackOptions }
            .distinctUntilChanged()
            .subscribe(onNext: { data in
                self.answersTags.addTags(data)
                self.addAccessibiltiyIdsToTags(in: self.answersTags)
            })
            .disposed(by: disposeBag)

        reactor
            .state
            .compactMap{$0.insight}
            .compactMap { $0.feedback }
            .subscribe(onNext: { feedback in
                guard let otherFeedtBackText = feedback.otherReasonText, !otherFeedtBackText.isEmpty else {
                    self.textViewPlaceHolder.isHidden = false
                    return
                }
                self.otherTextView.text = otherFeedtBackText
                self.textViewPlaceHolder.isHidden = true
            })
            .disposed(by: disposeBag)

        reactor
            .state
            .compactMap{$0.insight}
            .compactMap { $0.feedback.reason?.index }
            .distinctUntilChanged()
            .subscribe(onNext: { selectedOptionIndex in
                self.answersTags.selectedTags().forEach { $0.isSelected = false }
                self.answersTags.tagViews[selectedOptionIndex].isSelected = true
                self.showThankYou()
            })
            .disposed(by: disposeBag)
    }

    func showThankYou() {
        if thankYouLabel.alpha == 0 {
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.thankYouLabel.alpha = 1
            }
        }
    }

    // MARK: - Actions

    @IBAction func otherTextViewSubmitAction(_: Any) {
        hideOtherTextView()
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feedbackFreeText, .feedbackFreeTextSelected, [EventParamKey.feedbackFreeText: otherTextView.text ?? ""]))
        Observable
            .just(title)
            .map { _ in Reactor.Action.selectedFeedbackAnswer(displayString: "Other", otherText: self.otherTextView.text) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }

    @IBAction func otherTextviewCancelAction(_: Any) {
        hideOtherTextView()
    }

    /*
     QA
     **/
    private func addAccessibiltiyIdsToTags(in view: UIView) {
        for subview in view.subviews {
            if subview is TagView {
                let tag: TagView = subview as! TagView
                let title: String = tag.currentTitle ?? ""
                tag.accessibilityIdentifier = "answer_\(title.replacingOccurrences(of: " ", with: "_"))"
            } else {
                addAccessibiltiyIdsToTags(in: subview)
            }
        }
    }
}

extension FeedbackViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView _: TagView, sender _: TagListView) {
        let otherLabel = R.string.localizable.feedbackReasonOther()
        title == otherLabel ? showOtherTextView() : hideOtherTextView()
        Observable
            .just(title)
            .map { title in Reactor.Action.selectedFeedbackAnswer(displayString: title, otherText: self.otherTextView.text) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension FeedbackViewController {
    class func instantiate(with reactor: InsightViewReactor?) -> FeedbackViewController {
        let vc = R.storyboard.feedbackViewController.feedbackViewController()!
        vc.reactor = reactor
        return vc
    }
}

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceHolder.isHidden = !textView.text.isEmpty
    }
}
