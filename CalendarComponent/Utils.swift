//
//  Utils.swift
//  CalendarComponent
//
//  Created by Abel Martinez  on 05/11/19.
//  Copyright © 2019 a7x. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }
extension UICollectionReusableView: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }

extension UICollectionView {
    func register(cellType type: UICollectionViewCell.Type) {
        register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("You need to register cell of type `\(T.reuseIdentifier)`")
        }
        
        return cell
    }
    
    func registerSupplementaryView(suplementaryViewType type: UICollectionReusableView.Type, kind: String) {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath) as? T else {
                fatalError("You need to register supplementaryView of type `\(T.reuseIdentifier)` for kind `\(elementKind)`")
        }
        return supplementaryView
    }
}

extension UITableView {
    func register(cellType type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("You need to register cell of type `\(T.reuseIdentifier)`")
        }
        
        return cell
    }
}

extension UIFont {
    
    class func medium(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-Medium", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func mediumItalic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-MediumItalic", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func bold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "MyFontBold", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func boldItalic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-BoldItalic", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func black(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-Black", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func blackItalic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-BlackItalic", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func light(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-Light", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func lightItalic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamProL-LightItalic", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func italic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro-Italic", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
    
    class func regular(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "GothamPro", size: ofSize) ?? systemFont(ofSize: ofSize)
    }
}

