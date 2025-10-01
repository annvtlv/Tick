//
//  TaskTableViewCell.swift
//  Tick
//
//  Created by Анна Ветелева on 22.09.2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let checkboxButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(checkboxButton)
        contentView.addSubview(titleLabel)
        
        [titleLabel, checkboxButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 10)
        ])
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        checkboxButton.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
