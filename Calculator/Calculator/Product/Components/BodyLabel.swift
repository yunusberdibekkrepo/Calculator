//
//  BodyLabel.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

final class BodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    convenience init(alignment: NSTextAlignment, fontSize: CGFloat = 40) {
        self.init(frame: .zero)
        textAlignment = alignment
        font = .systemFont(ofSize: fontSize, weight: .regular)
    }

    private func setUpLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
    }
}
