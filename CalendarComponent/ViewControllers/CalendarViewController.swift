//
//  CalendarViewController.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 05/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//
import UIKit

final class CalendarViewController: UIViewController {
    private var tableView = UITableView()
    private var headerMonthView = MonthHeaderView()
    private let formatter = DateFormatter()
    private var timeModels: [ScheduleModel] = []
    private var selectedSchedules: Set<Date> = [] {
        didSet {
            selectedView.reloadData()
        }
    }
    private let calendar = Calendar.current
    private let selectedView = SelectedSchedulesView()
    private lazy var todayDate: Date = {
        guard var date = calendar.date(bySetting: .weekday, value: 1, of: Date()) else { return Date() }
        date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? Date()
        return date
    }()
    

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedView)
        
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            selectedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11),
            selectedView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let headerView = MonthHeaderView(delegate: self, dateFormatter: formatter)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: selectedView.bottomAnchor, constant: 24),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24)
        ])
        
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 17),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1.00)
        self.tableView = tableView
        self.headerMonthView = headerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Groups"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: WeekDayCell.self)
        
        selectedView.delegate = self
        selectedView.dataSource = self
    }
}

extension CalendarViewController: UITableViewDelegate {
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

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeekDayCell = tableView.dequeueCell(for: indexPath)
        guard let date = calendar.date(bySetting: .weekday, value: indexPath.row+1, of: todayDate) else { return cell }
        let selectedDates = selectedSchedules.filter { (selectedDate) -> Bool in
            return calendar.isDate(selectedDate, inSameDayAs: date)
        }
        print(date)
        cell.configure(for: date, dateFormatter: formatter, delegate: self, selectedDates: selectedDates)
        return cell
    }
}

extension CalendarViewController: MonthHeaderViewDelegate {
    func monthHeaderView(monthHeaderView: MonthHeaderView, didChangeDirection direction: MonthHeaderViewDirection) {
        todayDate = calendar.date(byAdding: .weekOfYear, value: direction.rawValue, to: todayDate) ?? Date()
        tableView.reloadData()
    }
}

extension CalendarViewController: WeekDayCellDelegate {
    func weekDayCell(cell: WeekDayCell, didSelectSchedule schedule: Date) {
        selectedSchedules.insert(schedule)
    }
    
    func weekDayCell(cell: WeekDayCell, didDeselectSchedule schedule: Date) {
        if selectedSchedules.contains(schedule) {
            selectedSchedules.remove(schedule)
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
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

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sortedSchedules = selectedSchedules.sorted()
        let date = sortedSchedules[indexPath.row]
        if selectedSchedules.contains(date) {
            selectedSchedules.remove(date)
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

