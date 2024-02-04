//
//  HeaderReusableViewCell.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

final class HeaderReusableViewCell: UICollectionReusableView {
    static let reuseIdentifier: String = "HeaderReusableViewCell"

    // MARK: - UI Components

    private let titleLabel: TitleLabel = .init(textAlignment: .right)

    // MARK: -  Variables

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public func configure(with text: String) {
        titleLabel.text = text
    }
}

extension HeaderReusableViewCell {
    private func style() {
        backgroundColor = .systemBackground
    }

    private func layout() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}
