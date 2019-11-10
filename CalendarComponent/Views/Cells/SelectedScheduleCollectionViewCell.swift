//
//  SelectedScheduleCollectionViewCell.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 07/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

class SelectedScheduleCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            shouldSelect()
        }
    }
    
    private lazy var dayNumberView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red:0.63, green:0.43, blue:1.00, alpha:1.00)
        return view
    }()
    
    private lazy var dayNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.text = "5"
        return label
    }()
    
    private lazy var monthNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.text = "Aug"
        return label
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "8:00"
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
//        button.addTarget(self, action: #selector(deselect(sender:)), for: .touchUpInside)
        return button
    }()
    
    var deleteSchedule:(Date) -> () = {_ in }
    var date: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = UIColor(red:0.80, green:0.69, blue:1.00, alpha:1.00)
        
        dayNumberView.addSubview(dayNumberLabel)
        dayNumberView.addSubview(monthNameLabel)
        addSubview(dayNumberView)
        addSubview(scheduleLabel)
        addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            dayNumberView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayNumberView.widthAnchor.constraint(equalToConstant: 48),
            dayNumberView.heightAnchor.constraint(equalToConstant: 48),
            monthNameLabel.centerXAnchor.constraint(equalTo: dayNumberView.centerXAnchor),
            monthNameLabel.topAnchor.constraint(equalTo: dayNumberView.topAnchor, constant: 7),
            dayNumberLabel.centerXAnchor.constraint(equalTo: dayNumberView.centerXAnchor),
            dayNumberLabel.topAnchor.constraint(equalTo: monthNameLabel.bottomAnchor, constant: 0),
            scheduleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            scheduleLabel.leadingAnchor.constraint(equalTo: dayNumberView.trailingAnchor, constant: 8.5),
            deleteButton.leadingAnchor.constraint(equalTo: scheduleLabel.trailingAnchor, constant: 4),
            deleteButton.centerYAnchor.constraint(equalTo: scheduleLabel.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func shouldSelect() {
        
    }
    
    func configure(with date: Date, dateFormatter: DateFormatter) {
        self.date = date
        dateFormatter.dateFormat = "MMM"
        monthNameLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        dayNumberLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        scheduleLabel.text = dateFormatter.string(from: date)
    }
}
