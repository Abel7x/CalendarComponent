//
//  SelectedSchedulesView.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 07/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

final class SelectedSchedulesView: UICollectionView {
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: .zero, collectionViewLayout: layout)
        
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        register(cellType: SelectedScheduleCollectionViewCell.self)
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
