//
//  EpisodeCell.swift
//  CastPod
//
//  Created by William Yeung on 6/29/21.
//

import UIKit

class EpisodeCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "EpisodeCell"

    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            episodeImageView.setImage(with: episode.imageUrl, completion: nil)
            dateLabel.text = episode.pubDate?.stringWith(format: "MMM dd, yyyy")
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description?.removeHTML()?.removeNewLines()?.removeBackSlashes()
        }
    }
    
    // MARK: - Views
    private let episodeImageView = CPImageView(image: nil, contentMode: .scaleAspectFill)
    private let dateLabel = CPLabel(text: "", font: .systemFont(ofSize: 14, weight: .medium))
    private let titleLabel = CPLabel(text: "", font: .systemFont(ofSize: 16, weight: .bold))
    private let descriptionLabel = CPLabel(text: "", font: .systemFont(ofSize: 14, weight: .light))
    private lazy var labelStack = CPStackView(views: [dateLabel, titleLabel, descriptionLabel], axis: .vertical, spacing: 3, distribution: .fill, alignment: .fill)
    
    private let downloadingIndicatorLabel = CPLabel(text: "100%", font: .systemFont(ofSize: 24, weight: .black))
    
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
        backgroundColor = Colors.darkModeBackground
        episodeImageView.clipsToBounds = true
        episodeImageView.layer.cornerRadius = 15
        dateLabel.textColor = Colors.appTintColor
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 2
        downloadingIndicatorLabel.textColor = .white
        downloadingIndicatorLabel.textAlignment = .center
        downloadingIndicatorLabel.isHidden = true
    }
    
    private func layoutUI() {
        addSubviews(episodeImageView, labelStack)
        episodeImageView.setDimension(width: 100, height: 100)
        episodeImageView.center(to: self, by: .centerY)
        episodeImageView.anchor(leading: leadingAnchor, paddingLeading: 16)
        labelStack.center(to: episodeImageView, by: .centerY)
        labelStack.anchor(trailing: trailingAnchor, leading: episodeImageView.trailingAnchor, paddingTrailing: 16, paddingLeading: 16)
        
        episodeImageView.addSubview(downloadingIndicatorLabel)
        downloadingIndicatorLabel.anchor(top: episodeImageView.topAnchor, trailing: episodeImageView.trailingAnchor, bottom: episodeImageView.bottomAnchor, leading: episodeImageView.leadingAnchor)
    }
    
    func showDownloadingIndicatorsWith(progress: Double) {
        downloadingIndicatorLabel.text = "\(Int(progress * 100))%"
        downloadingIndicatorLabel.isHidden = false
        downloadingIndicatorLabel.backgroundColor = .init(white: 0.15, alpha: 0.75)
    }
    
    func hideDownloadingIndicators() {
        downloadingIndicatorLabel.isHidden = true
    }
}

