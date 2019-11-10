//
//  WeekDayCell.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 05/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

protocol WeekDayCellDelegate: AnyObject {
    func weekDayCell(cell: WeekDayCell, didSelectSchedule schedule: Date)
    func weekDayCell(cell: WeekDayCell, didDeselectSchedule schedule: Date)
}

final class WeekDayCell: UITableViewCell {
    
    private var numberOfDayView = UIView()
    private var headerView = UIView()
    private var dayNameLabel = UILabel()
    private var monthNameLabel = UILabel()
    private var dayNumberLabel = UILabel()
    private var schedulesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var state = false
    private var heightConstraint = NSLayoutConstraint()
    private var badgeView = UIView()
    
    private weak var formatter: DateFormatter?
    private let calendar = Calendar.current
    private var date = Date()
    
    private weak var delegate: WeekDayCellDelegate?
    private var selectedDates = Set<Date>()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shadowView)
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3.5),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.5),
            shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 17.5),
            shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -17.5)
        ])
        
        shadowView.layer.cornerRadius = 4
        shadowView.layer.shadowColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0).cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.backgroundColor = .white
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        shadowView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: shadowView.topAnchor),
            view.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            view.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
            view.rightAnchor.constraint(equalTo: shadowView.rightAnchor)
        ])
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 64)
        ])
        self.headerView = headerView
        self.heightConstraint = view.heightAnchor.constraint(equalToConstant: 64)
        
        heightConstraint.isActive = true
        let dayNameLabel = UILabel()
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.font = UIFont.medium(ofSize: 24)
        headerView.addSubview(dayNameLabel)
        NSLayoutConstraint.activate([
            dayNameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 13),
            dayNameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        dayNameLabel.numberOfLines = 1
        dayNameLabel.text = "Monday"
        dayNameLabel.textColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.00)
        self.dayNameLabel = dayNameLabel
        
        let numberOfDayView = UIView()
        numberOfDayView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(numberOfDayView)
        NSLayoutConstraint.activate([
            numberOfDayView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            numberOfDayView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            numberOfDayView.topAnchor.constraint(equalTo: headerView.topAnchor),
            numberOfDayView.widthAnchor.constraint(equalToConstant: 75)
        ])
        headerView.layer.cornerRadius = 4
        headerView.clipsToBounds = true
        numberOfDayView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.0)
        numberOfDayView.layer.cornerRadius = 4
        numberOfDayView.clipsToBounds = true
        self.numberOfDayView = numberOfDayView
        
        let monthNameLabel = UILabel()
        monthNameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(monthNameLabel)
        NSLayoutConstraint.activate([
            monthNameLabel.centerXAnchor.constraint(equalTo: numberOfDayView.centerXAnchor),
            monthNameLabel.topAnchor.constraint(equalTo: numberOfDayView.topAnchor, constant: 7)
        ])
        monthNameLabel.text = "Aug"
        monthNameLabel.font = UIFont.medium(ofSize: 14)
        self.monthNameLabel = monthNameLabel
        
        let dayNumberLabel = UILabel()
        dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(dayNumberLabel)
        NSLayoutConstraint.activate([
            dayNumberLabel.centerXAnchor.constraint(equalTo: numberOfDayView.centerXAnchor),
            dayNumberLabel.topAnchor.constraint(equalTo: monthNameLabel.bottomAnchor, constant: 4)
        ])
        dayNumberLabel.text = "5"
        dayNumberLabel.font = UIFont.medium(ofSize: 32)
        self.dayNumberLabel = dayNumberLabel
        
        let scheduleLayout = UICollectionViewFlowLayout()
        scheduleLayout.scrollDirection = .vertical
        let scheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: scheduleLayout)
        scheduleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleCollectionView)
        NSLayoutConstraint.activate([
            scheduleCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scheduleCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scheduleCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scheduleCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        scheduleCollectionView.allowsMultipleSelection = true
        scheduleCollectionView.backgroundColor = .white
        scheduleCollectionView.clipsToBounds = true
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
        scheduleCollectionView.register(cellType: AvailableScheduleCell.self)
        self.schedulesCollectionView = scheduleCollectionView
        
        let badgeView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = UIColor(red:0.60, green:0.38, blue:1.00, alpha:1.00)
        badgeView.layer.cornerRadius = 4
        numberOfDayView.addSubview(badgeView)
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: numberOfDayView.topAnchor, constant: 4),
            badgeView.trailingAnchor.constraint(equalTo: numberOfDayView.trailingAnchor, constant: -4),
            badgeView.widthAnchor.constraint(equalToConstant: 8),
            badgeView.heightAnchor.constraint(equalToConstant: 8)
        ])
        self.badgeView = badgeView
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(for date: Date, dateFormatter: DateFormatter, delegate: WeekDayCellDelegate?, selectedDates: Set<Date>) {
        state = true
        self.selectedDates = selectedDates
        badgeView.isHidden = selectedDates.isEmpty
        shouldExpandDayView()
        self.delegate = delegate
        self.date = date
        self.formatter = dateFormatter
        dateFormatter.dateFormat = "EEEE"
        dayNameLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMM"
        monthNameLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        dayNumberLabel.text = dateFormatter.string(from: date)
        schedulesCollectionView.reloadData()
    }
    
    func shouldExpandDayView(){
        state = !state
        heightConstraint.constant = state ? schedulesCollectionView.contentSize.height + 64 : 64
        headerView.backgroundColor = state ? UIColor(red:0.80, green:0.69, blue:1.00, alpha:1.00) : .white
        dayNameLabel.textColor = state ? UIColor(red:0.49, green:0.22, blue:1.00, alpha:1.00) : UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.00)
        numberOfDayView.backgroundColor = state ? UIColor(red:0.63, green:0.43, blue:1.00, alpha:1.00) : UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.0)
        monthNameLabel.textColor = state ? .white : .black
        dayNumberLabel.textColor = state ? .white : .black
        
    }
}

extension WeekDayCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AvailableScheduleCell = collectionView.dequeueCell(for: indexPath)
        guard let date = calendar.date(bySetting: .hour, value: indexPath.row + 8, of: date), let formatter = formatter else { return cell }
        cell.configure(with: date, formatter: formatter)
        let highlight = selectedDates.contains(date)
        cell.isSelected = highlight
        if highlight {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
            self.collectionView(collectionView, didSelectItemAt: indexPath)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false  )
            self.collectionView(collectionView, didDeselectItemAt: indexPath)
        }
        return cell
    }
    
}

extension WeekDayCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedDate = calendar.date(byAdding: .hour, value: indexPath.row + 8, to: date) else { return }
        badgeView.isHidden = false
        delegate?.weekDayCell(cell: self, didSelectSchedule: selectedDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedDate = calendar.date(byAdding: .hour, value: indexPath.row + 8, to: date) else { return }
        badgeView.isHidden = collectionView.indexPathsForSelectedItems?.isEmpty ?? true
        delegate?.weekDayCell(cell: self, didDeselectSchedule: selectedDate)
    }
}
