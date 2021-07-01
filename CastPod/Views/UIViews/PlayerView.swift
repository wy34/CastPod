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
        }
    }
    
    let player = AVPlayer()

    // MARK: - Views
    private let dismissButton = CPButton(image: SFSymbols.xmark, font: .systemFont(ofSize: 16, weight: .bold), tintColor: Colors.darkModeSymbol)
    private let descriptionButton = CPButton(image: SFSymbols.information, font: .systemFont(ofSize: 18, weight: .bold), tintColor: Colors.darkModeSymbol)
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

    private lazy var overallStack = CPStackView(views: [UIStackView(arrangedSubviews: [dismissButton, UIView(), descriptionButton]), episodeImageView, timeStack, artistStack, buttonStack, volumeStack], axis: .vertical, spacing: 20, distribution: .fill, alignment: .fill)
    
    private let descriptionViewLauncher = EpisodeDescriptionLauncher()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
        setupActions()
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
    }

    private func layoutUI() {
        addSubviews(overallStack)
        overallStack.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.85, hMult: 1.85)
        overallStack.center(to: self, by: .centerX)
        overallStack.center(to: self, by: .centerY)
        dismissButton.setDimension(height: 30)
        episodeImageView.setDimension(height: widthAnchor, hMult: 0.85)
        timeStack.setDimension(height: heightAnchor, hMult: 0.05)
        artistStack.setDimension(height: widthAnchor, hMult: 0.18)
        volumeStack.setDimension(height: widthAnchor, hMult: 0.1)
    }

    private func setupActions() {
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(displayDescriptionMenu), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playPauseAudio), for: .touchUpInside)
        timeSlider.addTarget(self, action: #selector(scrubEpisodeTime), for: .valueChanged)
        backwardButton.addTarget(self, action: #selector(rewind15), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forward15), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(changeVolume), for: .valueChanged)
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
        } else {
            player.pause()
            playButton.setImage(SFSymbols.playButton.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 32, weight: .bold))), for: .normal)
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

    // MARK: - Selector
    @objc func dismissView() {
        removeFromSuperview()
    }
    
    @objc func displayDescriptionMenu() {
        guard let episode = episode, let description = episode.description else { return }
        descriptionViewLauncher.showDescriptionLauncherWith(description: description)
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











