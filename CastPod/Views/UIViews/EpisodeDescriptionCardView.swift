//
//  CardView.swift
//  CastPod
//
//  Created by William Yeung on 7/1/21.
//

import UIKit

class EpisodeDescriptionCardView: UIView {
    // MARK: - Properties
    var episodeDescription: String? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let reuseId = "cell"
    
    // MARK: - Views
    private let titleLabel = CPLabel(text: "Description", font: .systemFont(ofSize: 26, weight: .bold))
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        tv.backgroundColor = Colors.darkModeBackground
        tv.allowsSelection = false
        tv.separatorStyle = .none
        tv.contentInset = .init(top: 4, left: 0, bottom: 4, right: 0)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
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
        layer.cornerRadius = 15
        backgroundColor = .systemGray4
    }
    
    private func layoutUI() {
        addSubviews(titleLabel, tableView)
        titleLabel.anchor(top: topAnchor, trailing: trailingAnchor, leading: leadingAnchor, paddingTrailing: 16, paddingLeading: 16)
        titleLabel.setDimension(height: widthAnchor, hMult: 0.15)
        tableView.anchor(top: titleLabel.bottomAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EpisodeDescriptionCardView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = episodeDescription?.removeHTML()?.removeNewLines()?.removeBackSlashes() ?? ""
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .clear
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        return cell
    }
}
