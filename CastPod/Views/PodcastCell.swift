//
//  PodcastCell.swift
//  CastPod
//
//  Created by William Yeung on 6/28/21.
//

import UIKit

class PodcastCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "PodcastCell"
    
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            titleLabel.text = podcast.trackName
            artistLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) episodes"
            podcastImageView.setImage(with: podcast.artworkUrl600, completion: nil)
        }
    }
    
    // MARK: - Views
    private let podcastImageView = CastPodImageView(image: nil, contentMode: .scaleAspectFill)
    private let titleLabel = CastPodLabel(text: "", font: .systemFont(ofSize: 18, weight: .bold))
    private let artistLabel = CastPodLabel(text: "", font: .systemFont(ofSize: 16, weight: .regular))
    private let episodeCountLabel = CastPodLabel(text: "", font: .systemFont(ofSize: 14, weight: .light))
    private lazy var labelStack = CastPodStackView(views: [titleLabel, artistLabel, episodeCountLabel], axis: .vertical, spacing: 3, distribution: .fill, alignment: .fill)
    
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
        podcastImageView.clipsToBounds = true
        podcastImageView.layer.cornerRadius = 15
        titleLabel.numberOfLines = 2
        episodeCountLabel.textColor = .gray
    }
    
    private func layoutUI() {
        addSubviews(podcastImageView, labelStack)
        podcastImageView.setDimension(width: 100, height: 100)
        podcastImageView.center(to: self, by: .centerY)
        podcastImageView.anchor(leading: leadingAnchor, paddingLeading: 16)
        labelStack.center(to: podcastImageView, by: .centerY)
        labelStack.anchor(trailing: trailingAnchor, leading: podcastImageView.trailingAnchor, paddingTrailing: 16, paddingLeading: 16)
    }
}
