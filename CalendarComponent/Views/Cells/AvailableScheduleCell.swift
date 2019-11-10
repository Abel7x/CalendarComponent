//
//  AvailableScheduleCell.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 05/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

final class AvailableScheduleCell: UICollectionViewCell {
    
    private var timeLabel = UILabel()
    override var isSelected: Bool {
        didSet {
            shouldSelect()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.00)
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.medium(ofSize: 20)
        contentView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
        timeLabel.text = "8:00"
        timeLabel.textAlignment = .center
        self.timeLabel = timeLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func shouldSelect() {
        timeLabel.textColor = isSelected ? .white : .black
        backgroundColor = isSelected ? UIColor(red: 0.63, green: 0.43, blue: 1.0, alpha: 1) : UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.00)
    }
    
    func configure(with date: Date, formatter: DateFormatter) {
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: date)
    }
}

