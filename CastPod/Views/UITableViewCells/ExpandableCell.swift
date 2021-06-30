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
    
    var expandableSection: ExpandableSection? {
        didSet {
            guard let expandableSection = expandableSection else { return }
            textLabel?.text = expandableSection.title
        }
    }
        
    // MARK: - Views
    private let showHideButton = CPButton(title: "Show", bgColor: .clear, font: .systemFont(ofSize: 18, weight: .medium))
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layoutUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        textLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        showHideButton.setTitleColor(Colors.appTintColor, for: .normal)
    }
    
    private func layoutUI() {
        addSubview(showHideButton)
        showHideButton.center(to: self, by: .centerY)
        showHideButton.setDimension(width: 50)
        showHideButton.anchor(trailing: trailingAnchor, paddingTrailing: 20)
    }
    
    private func setupActions() {
        showHideButton.addTarget(self, action: #selector(showHideDescription), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func showHideDescription() {
        NotificationCenter.default.post(name: .shouldShowHideEpisodeDescription, object: nil)
        
        guard let expandableSection = expandableSection else { return }

        if expandableSection.isOpen {
            showHideButton.setTitle("Show", for: .normal)
        } else {
            showHideButton.setTitle("Hide", for: .normal)
        }
    }
}

