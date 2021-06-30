//
//  PlayerDetailView.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit
import MarqueeLabel

class PlayerView: UIView {
    // MARK: - Properties
    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            episodeImageView.setImage(with: episode.imageUrl, completion: nil)
            titleLabel.text = "\(episode.title ?? "")               "
            artistLabel.text = episode.artist
        }
    }

    // MARK: - Views
    private let dismissButton = CPButton(title: "Dismiss", bgColor: .clear, font: .systemFont(ofSize: 16, weight: .medium))
    private let episodeImageView = CPImageView(image: nil, contentMode: .scaleAspectFill)

    private let timeSlider = CPSlider(minValue: 0, maxValue: 1, image: SFSymbols.circle)
    private let minTimeLabel = CPLabel(text: "00:00:00", font: .systemFont(ofSize: 14, weight: .regular))
    private let maxTimeLabel = CPLabel(text: "00:00:00", font: .systemFont(ofSize: 14, weight: .regular))
    private lazy var timeLabelStack = CPStackView(views: [minTimeLabel, maxTimeLabel], distribution: .fillEqually, alignment: .center)
    private lazy var timeStack = CPStackView(views: [timeSlider, timeLabelStack], axis: .vertical, distribution: .fillEqually, alignment: .fill)

    private let titleLabel = MarqueeLabel(frame: .zero, duration: 12, fadeLength: 25)
    private let artistLabel = CPLabel(text: "", font: .systemFont(ofSize: 20, weight: .medium))
    private lazy var artistStack = CPStackView(views: [titleLabel, artistLabel], axis: .vertical, spacing: 10, distribution: .fill, alignment: .fill)

    private let backwardButton = CPButton(image: SFSymbols.backward15, font: .systemFont(ofSize: 25, weight: .bold), tintColor: Colors.darkModeSymbol)
    private let playButton = CPButton(image: SFSymbols.playButton, font: .systemFont(ofSize: 32, weight: .bold), tintColor: Colors.darkModeSymbol)
    private let forwardButton = CPButton(image: SFSymbols.forward15, font: .systemFont(ofSize: 25, weight: .bold), tintColor: Colors.darkModeSymbol)
    private lazy var buttonStack = CPStackView(views: [backwardButton, playButton, forwardButton], distribution: .fillEqually, alignment: .fill)

    private let minVolImageView = CPButton(image: SFSymbols.volumeDown, font: .systemFont(ofSize: 10, weight: .bold), tintColor: Colors.darkModeSymbol)
    private let volumeSlider = CPSlider(minValue: 0, maxValue: 1)
    private let maxVolImageView = CPButton(image: SFSymbols.volumeUp, font: .systemFont(ofSize: 10, weight: .bold), tintColor: Colors.darkModeSymbol)
    private lazy var volumeStack = CPStackView(views: [minVolImageView, volumeSlider, maxVolImageView], spacing: 10, distribution: .fill, alignment: .fill)

    private lazy var overallStack = CPStackView(views: [dismissButton, episodeImageView, timeStack, artistStack, buttonStack, volumeStack], axis: .vertical, spacing: 16, distribution: .fill, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = Colors.darkModeBackground
        episodeImageView.clipsToBounds = true
        episodeImageView.layer.cornerRadius = 15
        timeSlider.tintColor = Colors.sliderTintColor
        minTimeLabel.textAlignment = .left
        maxTimeLabel.textAlignment = .right
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        artistLabel.textColor = Colors.appTintColor
        artistLabel.textAlignment = .center
        volumeSlider.tintColor = Colors.sliderTintColor
    }

    private func layoutUI() {
        addSubviews(overallStack)
        overallStack.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.8, hMult: 1.85)
        overallStack.center(to: self, by: .centerX)
        overallStack.center(to: self, by: .centerY, withMultiplierOf: 0.89)
        dismissButton.setDimension(height: 20)
        episodeImageView.setDimension(height: widthAnchor, hMult: 0.8)
        timeStack.setDimension(height: heightAnchor, hMult: 0.05)
        artistStack.setDimension(height: widthAnchor, hMult: 0.18)
        volumeStack.setDimension(height: widthAnchor, hMult: 0.1)
    }

    private func setupActions() {
        dismissButton.addTarget(self, action: #selector(sendPlayerDismissalNotification), for: .touchUpInside)
    }

    // MARK: - Selector
    @objc func sendPlayerDismissalNotification() {
        NotificationCenter.default.post(name: .shouldDismissPlayerDetailView, object: nil)
    }
}











