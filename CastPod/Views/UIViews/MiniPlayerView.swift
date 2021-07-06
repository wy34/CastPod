//
//  MiniPlayerView.swift
//  CastPod
//
//  Created by William Yeung on 7/1/21.
//

import UIKit
import AVKit
import MarqueeLabel

protocol MiniPlayerViewDelegate: AnyObject {
    func handlePlayPausePressed()
    func handleForward15Pressed()
}

class MiniPlayerView: UIView {
    // MARK: - Properties
    var currentPlayer: AVPlayer?
    weak var delegate: MiniPlayerViewDelegate?
    
    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            setupEpisodeArtwork(episode: episode)
            titleLabel.text = "\(episode.title ?? "")               "
        }
    }
    
    // MARK: - Views
    private let episodeImageView = CPImageView(image: nil, contentMode: .scaleAspectFit)
    private let titleLabel = MarqueeLabel(frame: .zero, duration: 12, fadeLength: 25)
    private let playPauseButton = CPButton(image: SFSymbols.playButton, font: .systemFont(ofSize: 20, weight: .bold), tintColor: Colors.darkModeSymbol)
    private let forwardButton = CPButton(image: SFSymbols.forward15, font: .systemFont(ofSize: 20, weight: .bold), tintColor: Colors.darkModeSymbol)
    private lazy var miniPlayerStack = CPStackView(views: [episodeImageView, titleLabel, playPauseButton, forwardButton], spacing: 12, distribution: .fill)
    
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
        backgroundColor = .quaternarySystemFill
        episodeImageView.layer.cornerRadius = 10
        episodeImageView.clipsToBounds = true
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func layoutUI() {
        addSubviews(miniPlayerStack)
        miniPlayerStack.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor, paddingTrailing: 16, paddingLeading: 16)
        episodeImageView.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.8, hMult: 0.8)
        playPauseButton.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.4, hMult: 0.4)
        forwardButton.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.4, hMult: 0.4)
    }
    
    private func setupEpisodeArtwork(episode: Episode) {
        if episode.downloadedImageData != nil {
            episodeImageView.image = UIImage(data: episode.downloadedImageData ?? Data())
        } else {
            episodeImageView.setImage(with: episode.imageUrl, completion: nil)
        }
    }
    
    private func setupActions() {
        playPauseButton.addTarget(self, action: #selector(playPauseEpisode), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forward15), for: .touchUpInside)
    }
    
    func updatePlayPauseButtonTo(play: Bool) {
        if play {
            playPauseButton.setImage(SFSymbols.pauseButton.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 20, weight: .bold))), for: .normal)
        } else {
            playPauseButton.setImage(SFSymbols.playButton.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 20, weight: .bold))), for: .normal)
        }
    }
    
    // MARK: - Selectors
    @objc func playPauseEpisode() {
        updatePlayPauseButtonTo(play: currentPlayer?.timeControlStatus == .paused)
        delegate?.handlePlayPausePressed()
    }
    
    @objc func forward15() {
        delegate?.handleForward15Pressed()
    }
}
