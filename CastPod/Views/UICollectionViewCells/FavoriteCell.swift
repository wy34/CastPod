//
//  FavoriteCell.swift
//  CastPod
//
//  Created by William Yeung on 7/3/21.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "FavoriteCell"
    
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            podcastImageView.setImage(with: podcast.artworkUrl600, completion: nil)
            titleLabel.text = podcast.trackName
            artistLabel.text = podcast.artistName
        }
    }
    
    // MARK: - Views
    private let podcastImageView = CPImageView(image: Asset.placeholder, contentMode: .scaleAspectFill)
    private let titleLabel = CPLabel(text: "Podcast Name", font: .systemFont(ofSize: 18, weight: .bold))
    private let artistLabel = CPLabel(text: "Artist Name", font: .systemFont(ofSize: 16, weight: .regular))
    private lazy var labelStack = CPStackView(views: [titleLabel, artistLabel], axis: .vertical, spacing: -20, distribution: .fillEqually, alignment: .fill)

    private lazy var podcastStack = CPStackView(views: [podcastImageView, labelStack], axis: .vertical, distribution: .fill, alignment: .fill)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        podcastImageView.layer.cornerRadius = 15
        podcastImageView.clipsToBounds = true
        artistLabel.textColor = .systemGray
        
//        titleLabel.backgroundColor = .red
//        artistLabel.backgroundColor = .blue
    }
    
    private func layoutUI() {
        addSubview(podcastStack)
        podcastStack.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
        podcastImageView.setDimension(width: widthAnchor, height: widthAnchor)
    }
}
