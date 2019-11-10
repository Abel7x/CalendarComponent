//
//  CalendarViewController.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 05/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//
import UIKit

final class CalendarViewController: UIViewController {

    private lazy var calendarView: CalendarView = {
       let calendarView = CalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()

    override func loadView() {
        super.loadView()
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

