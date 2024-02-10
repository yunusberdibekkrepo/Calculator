//
//  TitleLabel.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

final class TitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat = 72) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        font = .systemFont(ofSize: fontSize, weight: .regular)
    }

    private func setUpLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        textColor = .secondaryLabel
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}
