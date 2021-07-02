//
//  PlayerDetailView.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit
import MarqueeLabel
import AVKit

class PlayerView: UIView {
    // MARK: - Properties
    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            episodeImageView.setImage(with: episode.imageUrl, completion: nil)
            titleLabel.text = "\(episode.title ?? "")               "
            artistLabel.text = episode.artist
            playAudioAt(urlString: episode.streamUrl)
            miniPlayerView.episode = episode
        }
    }
    
    let player = AVPlayer()
    
    // MARK: - Views
    private let miniPlayerView = MiniPlayerView()
    
    private let dismissButton = CPButton(image: SFSymbols.xmark, font: .systemFont(ofSize: 18, weight: .bold), tintColor: Colors.darkModeSymbol)
    private let descriptionButton = CPButton(image: SFSymbols.information, font: .systemFont(ofSize: 20, weight: .bold), tintColor: Colors.darkModeSymbol)
    private lazy var topButtonStack = CPStackView(views: [dismissButton, UIView(), descriptionButton], distribution: .fill)
    
    private let episodeImageView = CPImageView(image: nil, contentMode: .scaleAspectFill)

    private let timeSlider = CPSlider(minValue: 0, maxValue: 1, image: SFSymbols.circle)
    private let minTimeLabel = CPLabel(text: "--:--:--", font: .systemFont(ofSize: 14, weight: .regular))
    private let maxTimeLabel = CPLabel(text: "--:--:--", font: .systemFont(ofSize: 14, weight: .regular))
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

    private lazy var overallStack = CPStackView(views: [topButtonStack, episodeImageView, timeStack, artistStack, buttonStack, volumeStack], axis: .vertical, spacing: 20, distribution: .fill, alignment: .fill)
    
    private let blackBgView = CPView(bgColor: .black.withAlphaComponent(0.4))
    private let episodeDescriptionCardView = EpisodeDescriptionCardView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupActionsAndGestures()
        setupEpisodePlaybackDetails()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Helpers
    private func configureUI() {
        backgroundColor = Colors.darkModeBackground
        episodeImageView.clipsToBounds = true
        episodeImageView.layer.cornerRadius = 15
        episodeImageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        timeSlider.tintColor = Colors.sliderTintColor
        minTimeLabel.textAlignment = .left
        maxTimeLabel.textAlignment = .right
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        artistLabel.textColor = Colors.appTintColor
        artistLabel.textAlignment = .center
        volumeSlider.tintColor = Colors.sliderTintColor
        blackBgView.alpha = 0
        miniPlayerView.delegate = self
        miniPlayerView.currentPlayer = player
    }

    private func layoutUI() {
        addSubviews(overallStack, miniPlayerView)
        miniPlayerView.anchor(top: topAnchor, trailing: trailingAnchor, leading: leadingAnchor)
        miniPlayerView.setDimension(height: 64)
        
        overallStack.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.85, hMult: 1.85)
        overallStack.center(x: centerXAnchor, y: centerYAnchor)
        topButtonStack.setDimension(height: widthAnchor, hMult: 0.075)
        episodeImageView.setDimension(height: widthAnchor, hMult: 0.85)
        timeStack.setDimension(height: heightAnchor, hMult: 0.05)
        artistStack.setDimension(height: widthAnchor, hMult: 0.18)
        volumeStack.setDimension(height: widthAnchor, hMult: 0.1)
    }

    private func setupActionsAndGestures() {
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(displayDescriptionMenu), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playPauseAudio), for: .touchUpInside)
        timeSlider.addTarget(self, action: #selector(scrubEpisodeTime), for: .valueChanged)
        backwardButton.addTarget(self, action: #selector(rewind15), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forward15), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(changeVolume), for: .valueChanged)
        blackBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDescriptionMenu)))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maximizePlayerView)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragToDismissPlayerView)))
        miniPlayerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragMiniPlayerView)))
    }
    
    private func playAudioAt(urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
        let newPlayerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: newPlayerItem)
        updatePlayPauseButtonTo(play: true)
        volumeSlider.value = player.volume 
    }
    
    private func setupEpisodePlaybackDetails() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.scaleImageView(up: true)
            self?.maxTimeLabel.text = self?.player.currentItem?.duration.toFormattedString()
            self?.setupEpisodeTimeStack()
        }
    }
    
    private func setupEpisodeTimeStack() {
        let time = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            self?.minTimeLabel.text = time.toFormattedString()
            self?.updateTimeSlider()
        }
    }
    
    private func updatePlayPauseButtonTo(play: Bool) {
        if play {
            player.play()
            playButton.setImage(SFSymbols.pauseButton.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 32, weight: .bold))), for: .normal)
            miniPlayerView.updatePlayPauseButtonTo(play: true)
        } else {
            player.pause()
            playButton.setImage(SFSymbols.playButton.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 32, weight: .bold))), for: .normal)
            miniPlayerView.updatePlayPauseButtonTo(play: false)
        }
    }
    
    private func scaleImageView(up: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveEaseIn]) {
            self.episodeImageView.transform = up ? .identity : CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    
    private func updateTimeSlider() {
        let currentElapsedTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let totalEpisodeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let sliderValue = currentElapsedTimeSeconds / totalEpisodeSeconds
        timeSlider.value = Float(sliderValue)
    }
    
    private func seek(seconds: Float64) {
        let cmTimeSeconds = CMTimeMakeWithSeconds(seconds, preferredTimescale: 1)
        let seekTime = player.currentTime() + cmTimeSeconds
        player.seek(to: seekTime)
    }
    
    func hideMainPlayerView() {
        overallStack.alpha = 0
        miniPlayerView.alpha = 1
    }
    
    func showMainPlayerView() {
        overallStack.alpha = 1
        miniPlayerView.alpha = 0
    }

    // MARK: - Selector
    @objc func dismissView() {
        UIApplication.shared.rootViewController?.minimizePlayerView()
    }
    
    @objc func maximizePlayerView() {
        UIApplication.shared.rootViewController?.maximizePlayerView(episode: nil)
    }
    
    @objc func displayDescriptionMenu() {
        let keyWindow = UIApplication.shared.keyWindow

        blackBgView.frame = .init(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
        episodeDescriptionCardView.frame = .init(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: keyWindow.frame.height / 2)
        episodeDescriptionCardView.episodeDescription = episode?.description
        
        keyWindow.addSubviews(blackBgView, episodeDescriptionCardView)

        UIView.animate(withDuration: 0.5) {
            self.blackBgView.alpha = 1
            self.episodeDescriptionCardView.frame.origin.y = keyWindow.frame.height / 2
        }
    }
    
    @objc func dismissDescriptionMenu() {
        let keyWindow = UIApplication.shared.keyWindow

        UIView.animate(withDuration: 0.5) {
            self.blackBgView.alpha = 0
            self.episodeDescriptionCardView.frame.origin.y = keyWindow.frame.height
        } completion: { _ in
            self.blackBgView.removeFromSuperview()
            self.episodeDescriptionCardView.removeFromSuperview()
        }
    }
    
    @objc func dragMiniPlayerView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        if gesture.state == .changed {
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            self.miniPlayerView.alpha = 1 + translation.y / 500
            self.overallStack.alpha = -translation.y / 500
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.transform = .identity

                if translation.y < -250 || velocity.y < -250 {
                    self.maximizePlayerView()
                } else {
                    self.miniPlayerView.alpha = 1
                    self.overallStack.alpha = 0
                }
            }
        }
    }
    
    @objc func dragToDismissPlayerView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        if gesture.state == .changed && translation.y > 0 {
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.35) {
                self.transform = .identity
                if translation.y > 50 { UIApplication.shared.rootViewController?.minimizePlayerView() }
            }
        }
    }
    @objc func playPauseAudio() {
        let isPaused = player.timeControlStatus == .paused
        updatePlayPauseButtonTo(play: isPaused)
        scaleImageView(up: isPaused)
    }

    @objc func scrubEpisodeTime() {
        let sliderPercentage = timeSlider.value
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let seekTimeSeconds = Float64(sliderPercentage) * durationSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @objc func rewind15() {
        seek(seconds: -15)
    }
    
    @objc func forward15() {
        seek(seconds: 15)
    }
    
    @objc func changeVolume() {
        player.volume = volumeSlider.value
    }
}

// MARK: - MiniPlayerViewDelegate
extension PlayerView: MiniPlayerViewDelegate {
    func handlePlayPausePressed() {
        playPauseAudio()
    }
    
    func handleForward15Pressed() {
        forward15()
    }
}








