//
//  PlayerView.swift
//  CastPod
//
//  Created by William Yeung on 6/30/21.
//

import UIKit

class PlayerDetailView: UIView {
    // MARK: - Properties
    var episode: Episode?
    let reuseId = "cell"
    var descriptionSection = ExpandableSection(title: "Description", cellTitles: ["1"])
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tv.register(ExpandableCell.self, forCellReuseIdentifier: ExpandableCell.reuseId)
        tv.backgroundColor = Colors.darkModeBackground
//        tv.allowsSelection = false
        tv.delegate = self
        tv.dataSource = self
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
       
    }

    private func layoutUI() {
        addSubview(tableView)
        tableView.anchor(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, leading: leadingAnchor)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlayerDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let playerView = PlayerView()
        playerView.episode = episode
        return playerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionSection.isOpen ? descriptionSection.cellTitles.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: ExpandableCell.reuseId, for: indexPath) as! ExpandableCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .tertiarySystemBackground
            cell.textLabel?.font = .systemFont(ofSize: 16)
            cell.textLabel?.text = episode?.description ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            descriptionSection.isOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}
