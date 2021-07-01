//
//  EpisodeDescriptionView.swift
//  CastPod
//
//  Created by William Yeung on 6/30/21.
//

import UIKit

class EpisodeDescriptionLauncher: UIView {
    // MARK: - Properties
    let keyWindow = UIApplication.shared.keyWindow

    // MARK: - Views
    private let blackBgView = CPView(bgColor: .black.withAlphaComponent(0.4))
    private let descriptionCardView = CPView(bgColor: .red)
    private let titleLabel = CPLabel(text: "Description", font: .systemFont(ofSize: 26, weight: .bold))

    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = Colors.darkModeBackground
        tv.font = .systemFont(ofSize: 20, weight: .medium)
        tv.showsVerticalScrollIndicator = false
        tv.contentInset = .init(top: 14, left: 14, bottom: 14, right: 14)
        tv.isEditable = false
        return tv
    }()
        
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupDismissalGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        blackBgView.alpha = 0
        descriptionCardView.layer.cornerRadius = 15
        descriptionCardView.backgroundColor = .systemGray5
    }
    
    private func layoutUI() {
        descriptionCardView.addSubviews(titleLabel, descriptionTextView)
        titleLabel.anchor(top: descriptionCardView.topAnchor, trailing: descriptionCardView.trailingAnchor, leading: descriptionCardView.leadingAnchor, paddingTrailing: 16, paddingLeading: 16)
        titleLabel.setDimension(height: descriptionCardView.widthAnchor, hMult: 0.15)
        descriptionTextView.anchor(top: titleLabel.bottomAnchor, trailing: descriptionCardView.trailingAnchor, bottom: descriptionCardView.bottomAnchor, leading: descriptionCardView.leadingAnchor)
    }
    
    private func setupDismissalGesture() {
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDescriptionLauncher)))
    }
    
    func showDescriptionLauncherWith(description: String) {
        descriptionTextView.text = description.removeHTML()?.removeNewLines()?.removeBackSlashes()
        
        keyWindow.addSubviews(blackBgView, descriptionCardView)
        
        blackBgView.frame = keyWindow.frame
        descriptionCardView.frame = .init(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: keyWindow.frame.height / 2)
        
        UIView.animate(withDuration: 0.5) {
            self.blackBgView.alpha = 1
            self.descriptionCardView.frame.origin.y = self.keyWindow.frame.height / 2
        }
    }
    
    // MARK: - Selectors
    @objc func dismissDescriptionLauncher() {
        UIView.animate(withDuration: 0.5) {
            self.blackBgView.alpha = 0
            self.descriptionCardView.frame.origin.y = self.keyWindow.frame.height
        } completion: { _ in
            self.blackBgView.removeFromSuperview()
            self.descriptionCardView.removeFromSuperview()
        }
    }
}
