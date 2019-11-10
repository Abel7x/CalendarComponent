//
//  MonthHeaderView.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 05/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

enum MonthHeaderViewDirection: Int {
    case right = 1
    case left = -1 
}

protocol MonthHeaderViewDelegate: AnyObject {
    func monthHeaderView(monthHeaderView: MonthHeaderView, didChangeDirection direction: MonthHeaderViewDirection)
}

class MonthHeaderView: UIView {
    private var leftArrowButton = UIButton()
    private var rightArrowButton = UIButton()
    private var monthNameLabel = UILabel()
    private let calendar = Calendar.current
    private lazy var dateComponents: DateComponents = {
        let dateComponents = self.calendar.dateComponents([.weekOfYear, .month], from: self.date ?? Date())
        return dateComponents
    }()
    
    weak var delegate: MonthHeaderViewDelegate?
    private weak var dateFormatter: DateFormatter?
    private var date: Date? {
        didSet {
            updateMonth()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init(delegate: MonthHeaderViewDelegate, dateFormatter: DateFormatter, date: Date = Date()){
        self.init()
        self.delegate = delegate
        self.date = date
        self.dateFormatter = dateFormatter
        self.updateMonth()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //common func to init our view
    private func setupView() {
        let monthNameLabel = UILabel()
        monthNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(monthNameLabel)
        NSLayoutConstraint.activate([
            monthNameLabel.topAnchor.constraint(equalTo: topAnchor),
            monthNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            monthNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        monthNameLabel.textAlignment = .center
        monthNameLabel.font = UIFont.bold(ofSize: 16)
        self.monthNameLabel = monthNameLabel
        
        let leftArrowButton = UIButton()
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.addTarget(self, action: #selector(handleLeftAction(sender:)), for: .touchUpInside)
        addSubview(leftArrowButton)
        NSLayoutConstraint.activate([
            leftArrowButton.trailingAnchor.constraint(equalTo: monthNameLabel.leadingAnchor, constant: -10),
            leftArrowButton.centerYAnchor.constraint(equalTo: monthNameLabel.centerYAnchor),
            leftArrowButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        leftArrowButton.setTitleColor(.black, for: .normal)
        leftArrowButton.setImage(UIImage(named: "left arrow"), for: .normal)
        self.leftArrowButton = leftArrowButton
        
        let rightArrowButton = UIButton()
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.addTarget(self, action: #selector(handleRightAction(sender:)), for: .touchUpInside)
        addSubview(rightArrowButton)
        NSLayoutConstraint.activate([
            rightArrowButton.leadingAnchor.constraint(equalTo: monthNameLabel.trailingAnchor, constant: 10),
            rightArrowButton.centerYAnchor.constraint(equalTo: monthNameLabel.centerYAnchor),
            rightArrowButton.widthAnchor.constraint(equalToConstant: 20),
            rightArrowButton.heightAnchor.constraint(equalTo: rightArrowButton.widthAnchor)
        ])
        rightArrowButton.setTitleColor(.black, for: .normal)
        rightArrowButton.setImage(UIImage(named: "right arrow"), for: .normal)
        self.rightArrowButton = rightArrowButton
    }
    
    @objc private func handleRightAction(sender: UIButton) {
        date = calendar.date(byAdding: .weekOfYear, value: +1, to: date!)
        delegate?.monthHeaderView(monthHeaderView: self, didChangeDirection: .right)
    }
    
    @objc private func handleLeftAction(sender: UIButton) {
        date = calendar.date(byAdding: .weekOfYear, value: -1, to: date!)
        delegate?.monthHeaderView(monthHeaderView: self, didChangeDirection: .left)
    }
    
    func update(date: Date) {
        self.date = date
    }
    
    private func updateMonth() {
        guard let dateFormatter = dateFormatter, let date = date else { return }
        dateFormatter.dateFormat = "MMMM YYYY"
        monthNameLabel.text = dateFormatter.string(from: date)
    }
    
}
