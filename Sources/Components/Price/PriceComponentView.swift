//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class PriceComponentView: UIView {
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.font = .title1
        label.textColor = .licorice
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.font = .title1
        label.textColor = .licorice
        return label
    }()

    var component: PriceComponent? {
        didSet {
            guard let component = component else {
                return
            }

            priceLabel.text = component.priceLabel
            accessibilityLabel = component.accessibilityLabel
            statusLabel.text = component.status

            let statusIsEmpty = component.status?.isEmpty ?? false
            if statusIsEmpty {
                priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing).isActive = true
            } else {
                NSLayoutConstraint.activate([
                    statusLabel.topAnchor.constraint(equalTo: topAnchor),
                    statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                    statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priceLabel.trailingAnchor, constant: .mediumLargeSpacing),
                    statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
                ])
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(priceLabel)
        addSubview(statusLabel)

        isAccessibilityElement = true

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
        ])
    }
}
