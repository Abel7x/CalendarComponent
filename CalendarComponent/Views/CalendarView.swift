//
//  CalendarView.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 10/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: CalendarView, didSelectDate date: Date)
    func calendarView(_ calendarView: CalendarView, didDeselectDate date: Date)
}

final class CalendarView: UIView {
    
    weak var delegate: CalendarViewDelegate?
    private let formatter = DateFormatter()
    private var selectedSchedules: Set<Date> = [] {
        didSet {
            selectedView.reloadData()
        }
    }
    
    var selectedDates: Set<Date> {
        return selectedSchedules
    }
    
    private let calendar = Calendar.current
    private lazy var todayDate: Date = {
        guard var date = calendar.date(bySetting: .weekday, value: 1, of: Date()) else { return Date() }
        date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? Date()
        return date
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.00)
        tableView.register(cellType: WeekDayCell.self)
        return tableView
    }()
    
    private lazy var headerMonthView: MonthHeaderView = {
        let headerView = MonthHeaderView(delegate: self, dateFormatter: formatter)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private lazy var selectedView: SelectedSchedulesView = {
        let selectedView = SelectedSchedulesView()
        selectedView.dataSource = self
        selectedView.delegate = self
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        return selectedView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init(delegate: CalendarViewDelegate){
        self.init()
        self.delegate = delegate
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //common func to init our view
    private func setupView() {
        backgroundColor = .white
        
        addSubview(selectedView)
        addSubview(headerMonthView)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            selectedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            selectedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            selectedView.heightAnchor.constraint(equalToConstant: 48),
            headerMonthView.topAnchor.constraint(equalTo: selectedView.bottomAnchor, constant: 24),
            headerMonthView.leftAnchor.constraint(equalTo: leftAnchor),
            headerMonthView.rightAnchor.constraint(equalTo: rightAnchor),
            headerMonthView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            tableView.topAnchor.constraint(equalTo: headerMonthView.bottomAnchor, constant: 17),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}


// MARK: -UITableViewDelegate
extension CalendarView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        71
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WeekDayCell else { return }
        
        cell.shouldExpandDayView()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: -UITableViewDataSource
extension CalendarView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeekDayCell = tableView.dequeueCell(for: indexPath)
        guard let date = calendar.date(bySetting: .weekday, value: indexPath.row+1, of: todayDate) else { return cell }
        let selectedDates = selectedSchedules.filter { (selectedDate) -> Bool in
            return calendar.isDate(selectedDate, inSameDayAs: date)
        }
        cell.configure(for: date, dateFormatter: formatter, delegate: self, selectedDates: selectedDates)
        return cell
    }
}

// MARK: -MonthHeaderViewDelegate
extension CalendarView: MonthHeaderViewDelegate {
    func monthHeaderView(monthHeaderView: MonthHeaderView, didChangeDirection direction: MonthHeaderViewDirection) {
        todayDate = calendar.date(byAdding: .weekOfYear, value: direction.rawValue, to: todayDate) ?? Date()
        tableView.reloadData()
    }
}

// MARK: -WeekDayCellDelegate
extension CalendarView: WeekDayCellDelegate {
    func weekDayCell(cell: WeekDayCell, didSelectSchedule schedule: Date) {
        selectedSchedules.insert(schedule)
        delegate?.calendarView(self, didSelectDate: schedule)
    }
    
    func weekDayCell(cell: WeekDayCell, didDeselectSchedule schedule: Date) {
        if selectedSchedules.contains(schedule) {
            delegate?.calendarView(self, didDeselectDate: schedule)
            selectedSchedules.remove(schedule)
        }
    }
}

// MARK: -UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSchedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectedScheduleCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let sortedSchedules = selectedSchedules.sorted()
        let date = sortedSchedules[indexPath.row]
        cell.configure(with: date, dateFormatter: formatter)
        return cell
    }
}

// MARK: -UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sortedSchedules = selectedSchedules.sorted()
        let date = sortedSchedules[indexPath.row]
        if selectedSchedules.contains(date) {
            selectedSchedules.remove(date)
            tableView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 146, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
