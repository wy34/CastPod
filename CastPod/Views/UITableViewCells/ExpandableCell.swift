//
//  ExpandableCell.swift
//  CastPod
//
//  Created by William Yeung on 6/30/21.
//

import UIKit

class ExpandableCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "ExpandableCell"
    
    // MARK: - Views
    private let showHideButton = CPButton(title: "Show", bgColor: .clear, font: .systemFont(ofSize: 18, weight: .regular))
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        textLabel?.text = "Description"
        textLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        showHideButton.setTitleColor(Colors.appTintColor, for: .normal)
    }
    
    private func layoutUI() {
        addSubview(showHideButton)
        showHideButton.center(to: self, by: .centerY)
        showHideButton.anchor(trailing: trailingAnchor, paddingTrailing: 20)
    }
}
