//
//  SGButton.swift
//  Openfield
//
//  Created by Daniel Kochavi on 28/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

open class SGButton: UIControl {
    enum TouchState {
        case touched
        case untouched
    }

    fileprivate let touchDisableRadius: CGFloat = 100.0

    fileprivate var rootView: UIView!
    @IBOutlet fileprivate var titleLbl: UILabel!
    @IBOutlet fileprivate var bgContentView: UIView!
    @IBOutlet fileprivate var btnImage: UIImageView!

    @IBOutlet fileprivate var btnImageHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var btnImageWidth: NSLayoutConstraint!
    @IBOutlet fileprivate var imageTitleSpacing: NSLayoutConstraint!

    @IBOutlet fileprivate var btnImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var bgContentWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var bgContentHeightConstraint: NSLayoutConstraint!

    @IBOutlet fileprivate var loadingView: UIView!
    @IBOutlet fileprivate var loadingLabel: UILabel!
    @IBOutlet fileprivate var activityIndicatorView: NVActivityIndicatorView!

    struct ButtonStyle {
        var bgColor: UIColor = .white
        var titleFont: UIFont = .systemFont(ofSize: 16)
        var titleColor: UIColor = .black
        var borderColor: UIColor = .clear
        var borderWidth: CGFloat = 1
    }

    struct ShadowProps {
        var shadowOffset: CGSize = .init(width: 5, height: 5)
        var shadowRadius: CGFloat = 0
        var shadowOpacity: CGFloat = 1
        var shadowColor: UIColor = .black
    }

    private var currentButtonStyle: ButtonStyle {
        if let disabledButtonStyle = disabledButtonStyle, !isEnabled {
            return disabledButtonStyle
        }
        let highlightedState = highlightedButtonStyle ?? defaultButtonStyle
        return pressed ? highlightedState : defaultButtonStyle
    }

    // MARK: - Control Properties

    // MARK:

    private var internalTitleString: String { return titleString }
    var defaultButtonStyle: ButtonStyle = .init()
    var highlightedButtonStyle: ButtonStyle?
    var disabledButtonStyle: ButtonStyle?
    var loadingButtonStyle: ButtonStyle = .init()
    var shadowProps: ShadowProps? = nil
    var titleNumOfLines: Int = 0
    var titleAlignment: NSTextAlignment = .left
    var imageTextSpacing: CGFloat = 7
    var showTouchFeedback: Bool = true
    var fullyRoundedCorners: Bool = false
    var cornerRadius: CGFloat = 0.0
    var internalDefaultImage: UIImage?
    var internalHighlightedImage: UIImage?
    var internalDisabledImage: UIImage?
    var currentImage: UIImage? {
        if isEnabled {
            return pressed ? internalHighlightedImage : internalDefaultImage
        } else {
            return internalDisabledImage
        }
    }

    var loadingTitleString: String = "" {
        didSet {
            loadingLabel.text = loadingTitleString
        }
    }

    var titleString: String = "" {
        didSet {
            setupView()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            setupView()
        }
    }

    var isloading: Bool = false {
        didSet {
            bgContentView.isUserInteractionEnabled = !isloading
            loadingView.isHidden = !isloading
            isloading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        }
    }

    // MARK: - Standard Properties

    // MARK:

    public var attributedString: NSAttributedString? {
        didSet {
            titleLbl.attributedText = attributedString
        }
    }

    @IBInspectable open var defaultImage: UIImage? = nil {
        didSet {
            internalDefaultImage = defaultImage
            setupView()
        }
    }

    @IBInspectable open var highlightedImage: UIImage? = nil {
        didSet {
            internalHighlightedImage = highlightedImage
            setupView()
        }
    }

    @IBInspectable open var disabledImage: UIImage? = nil {
        didSet {
            internalDisabledImage = disabledImage
            setupView()
        }
    }

    // MARK: - Overrides

    // MARK:

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        setupView()
    }

    private func setupStaticColor() {
        activityIndicatorView.color = R.color.valleyBrand()!
        activityIndicatorView.type = .circleStrokeSpin
    }

    override open func layoutSubviews() {
        setupBorderAndCorners()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        setupView()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        setupView()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: 10, height: 10)
    }

    // MARK: - Internal functions

    // MARK:

    // Setup the view appearance
    open func setupView() {
        loadingLabel.text = loadingTitleString
        bgContentView.clipsToBounds = true
        layer.masksToBounds = false
        setupTitle()
        setupBackgroundColor()
        setupBorderAndCorners()
        setupImage()
        setupSpacings()
        setupShadow()
        setupAlignment()
        setupLoadingView()
        setupAccessibility()
        setupStaticColor()
    }

    private func setupAccessibility() {
        accessibilityLabel = titleString
    }

    fileprivate func setupBackgroundColor() {
        bgContentWidthConstraint.constant = min(0, -currentButtonStyle.borderWidth)
        bgContentHeightConstraint.constant = min(0, -currentButtonStyle.borderWidth)
        bgContentView.backgroundColor = currentButtonStyle.bgColor
    }

    fileprivate func setupBorderAndCorners() {
        if fullyRoundedCorners {
            bgContentView.layer.cornerRadius = frame.size.height / 2
            layer.cornerRadius = frame.size.height / 2
        } else {
            bgContentView.layer.cornerRadius = cornerRadius
            layer.cornerRadius = cornerRadius
        }
        layer.borderColor = currentButtonStyle.borderColor.cgColor
        layer.borderWidth = currentButtonStyle.borderWidth
    }

    fileprivate func setupTitle() {
        titleLbl.isHidden = internalTitleString.isEmpty
        titleLbl.numberOfLines = titleNumOfLines
        titleLbl.text = internalTitleString
        titleLbl.textColor = currentButtonStyle.titleColor
        titleLbl.font = currentButtonStyle.titleFont
    }

    fileprivate func setupImage() {
        if let imageSrc = currentImage {
            let imageSrc = imageSrc

            btnImage.isHidden = false
            imageTitleSpacing.isActive = true
            imageTitleSpacing.constant = imageTextSpacing
            btnImageLeadingConstraint.isActive = true

            setupImageWith(imageView: btnImage,
                           image: imageSrc,
                           widthConstraint: btnImageWidth,
                           heightConstraint: btnImageHeight,
                           widthValue: 24,
                           heightValue: 24)
        } else { // hide the imageview and set constraints
            btnImage.isHidden = true
            imageTitleSpacing.isActive = false
            btnImageLeadingConstraint.isActive = false
        }
    }

    fileprivate func setupImageWith(imageView: UIImageView,
                                    image: UIImage?,
                                    widthConstraint: NSLayoutConstraint,
                                    heightConstraint: NSLayoutConstraint,
                                    widthValue: CGFloat,
                                    heightValue: CGFloat)
    {
        imageView.isHidden = image == nil
        if image != nil {
            image?.withRenderingMode(.alwaysOriginal)
            imageView.image = image
            widthConstraint.constant = widthValue
            heightConstraint.constant = heightValue
        }
        setupBorderAndCorners()
    }

    fileprivate func setupSpacings() {
        setupBorderAndCorners()
    }

    fileprivate func setupShadow() {
        if let shadowState = shadowProps, shadowState.shadowRadius > 0 {
            layer.shadowOffset = shadowState.shadowOffset
            layer.shadowRadius = shadowState.shadowRadius
            layer.shadowOpacity = Float(shadowState.shadowOpacity)
            layer.shadowColor = shadowState.shadowColor.cgColor
        }
    }

    fileprivate func setupAlignment() {
        titleLbl.textAlignment = titleAlignment
    }

    fileprivate func setupLoadingView() {
        loadingView.backgroundColor = loadingButtonStyle.bgColor
        loadingLabel.font = loadingButtonStyle.titleFont
        loadingLabel.textColor = loadingButtonStyle.titleColor
    }

    // MARK: - Xib file

    // MARK:

    fileprivate func xibSetup() {
        guard rootView == nil else {
            return
        }
        rootView = loadViewFromNib()
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rootView)
    }

    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SGButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

    // MARK: - Touches

    // MARK:

    var touchState: TouchState = .untouched {
        didSet {
            updateUI()
        }
    }

    var pressed: Bool = false {
        didSet {
            if !showTouchFeedback {
                return
            }
            touchState = pressed ? .touched : .untouched
        }
    }

    override open func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        pressed = true
    }

    override open func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        if pressed {
            sendActions(for: .touchUpInside)
        }
        pressed = false
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        if let touchLoc = touches.first?.location(in: self) {
            if touchLoc.x < -touchDisableRadius ||
                touchLoc.y < -touchDisableRadius ||
                touchLoc.x > bounds.size.width + touchDisableRadius ||
                touchLoc.y > bounds.size.height + touchDisableRadius
            {
                pressed = false
            } else if touchState == .untouched {
                pressed = true
            }
        }
    }

    override open func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        pressed = false
    }

    func updateUI() {
        bgContentView.backgroundColor = currentButtonStyle.bgColor
        titleLbl.textColor = currentButtonStyle.titleColor
        btnImage.image = currentImage
        layer.borderColor = currentButtonStyle.borderColor.cgColor
        layer.borderWidth = currentButtonStyle.borderWidth
    }
    
    func hideImage(hide: Bool) {
        btnImage.isHidden = hide
    }

    @IBAction func tapAction(_: Any) {
        sendActions(for: .touchUpInside)
    }
}

extension Reactive where Base: SGButton {
    var enable: Binder<Bool> {
        return Binder(base) { button, status in
            button.isEnabled = status
        }
    }

    var loading: Binder<Bool> {
        return Binder(base) { button, status in
            button.isloading = status
        }
    }
}
