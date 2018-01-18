import UIKit

protocol CollapsableDescriptionComponentViewDelegate: class {
    func collapsableDescriptionComponentView(_ collapsableDescriptionComponentView: CollapsableDescriptionComponentView, didTapExpandDescriptionFor component: CollapsableDescriptionComponent)
    func collapsableDescriptionComponentView(_ collapsableDescriptionComponentView: CollapsableDescriptionComponentView, didTapHideDescriptionFor component: CollapsableDescriptionComponent)
}

public class CollapsableDescriptionComponentView: UIView {

    // MARK: - Internal properties

    private var textHeightConstraint: NSLayoutConstraint?
    private var gradientHeightConstraint: NSLayoutConstraint?
    private var gradientLayer: CAGradientLayer?

    private var isWholeTextShowing: Bool = false
    private let isHidingCollapseButton: Bool = false        // Toggle switch for hiding collapse button after expaning
    private let collapsedDescriptionHeight: CGFloat = 200

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isAccessibilityElement = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.font = .body
        textView.textColor = .stone
        textView.contentMode = .topLeft
        return textView
    }()

    private lazy var gradientView: UIView = {
        let widthOfComponent = UIScreen.main.bounds.width - .mediumLargeSpacing*2
        let view = UIView(frame: CGRect(x: 0, y: 0, width: widthOfComponent, height: collapsedDescriptionHeight)) // Not dynamic (will not work for landscape mode)
        fadeBottom(of: view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var showWholeDescriptionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.setTitleColor(.primaryBlue, for: .normal)
        button.addTarget(self, action: #selector(showWholeDescriptionAction), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: .mediumSpacing, left: 0, bottom: .mediumSpacing, right: 0)
        button.titleLabel?.font = .title4
        return button
    }()

    // MARK: - External properties

    weak var delegate: CollapsableDescriptionComponentViewDelegate?
    var component: CollapsableDescriptionComponent? {
        didSet {
            descriptionTextView.text = component?.text
            showWholeDescriptionButton.setTitle(component?.titleShow, for: .normal)
            
            if descriptionTextView.sizeOfString.height <= collapsedDescriptionHeight {
                descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            } else {
                setupButton()
            }
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(descriptionTextView)

        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: topAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func showWholeDescriptionAction(sender: UIButton) {
        guard let component = component, let delegate = delegate else {
            return
        }

        if isWholeTextShowing {
            textHeightConstraint?.isActive = true
            gradientHeightConstraint?.isActive = true

            delegate.collapsableDescriptionComponentView(self, didTapHideDescriptionFor: component)
            isWholeTextShowing = false
        } else {
            textHeightConstraint?.isActive = false
            gradientHeightConstraint?.isActive = false
            showWholeDescriptionButton.heightAnchor.constraint(equalToConstant: 0).isActive = isHidingCollapseButton

            delegate.collapsableDescriptionComponentView(self, didTapExpandDescriptionFor: component)
            isWholeTextShowing = true
        }
    }

    func updateButtonTitle() {
        if isWholeTextShowing {
            showWholeDescriptionButton.setTitle(self.component?.titleHide, for: .normal)
        } else {
            showWholeDescriptionButton.setTitle(self.component?.titleShow, for: .normal)
        }
    }

    func setButtonShowing(showing: Bool) {
        if showing {
            showWholeDescriptionButton.alpha = 1
        } else {
            showWholeDescriptionButton.alpha = 0
            showWholeDescriptionButton.isHidden = isHidingCollapseButton
        }
    }

    func setupButton() {
        addSubview(showWholeDescriptionButton)
        addSubview(gradientView)

        textHeightConstraint = descriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: collapsedDescriptionHeight)
        gradientHeightConstraint = gradientView.heightAnchor.constraint(equalToConstant: collapsedDescriptionHeight)

        NSLayoutConstraint.activate([
            textHeightConstraint!,

            showWholeDescriptionButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            showWholeDescriptionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            showWholeDescriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            showWholeDescriptionButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            gradientView.bottomAnchor.constraint(equalTo: showWholeDescriptionButton.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientHeightConstraint!,
        ])
    }

    func fadeBottom(of view: UIView) {
        let startColor = UIColor(white: 1, alpha: 0).cgColor
        let endColor = UIColor(white: 1, alpha: 1).cgColor

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [startColor, endColor]
        gradient.locations = [0.7, 1]

        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
}