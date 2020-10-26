//
//  UtilityExtension.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
import UIKit
typealias JsonDictionay = [String : Any]

extension UIViewController {
    static func get(with identifier: String , storyboard name:String) -> UIViewController? {
        let storyboard = UIStoryboard.board(for: name)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
}

extension UIStoryboard {
    static func board(for name: String) -> UIStoryboard {
        let board = UIStoryboard(name: name, bundle: nil)
        return board
    }
}


extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    func cornerRadius(with radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}


extension UIColor {
    
    static var brightSkyBlue : UIColor {
        get {
            UIColor.init(displayP3Red: 10/255, green: 197/255, blue: 254/255, alpha: 1)
        }
    }
    
    static var skyBlue : UIColor {
        get {
            UIColor.init(displayP3Red: 79/255, green: 170/255, blue: 254/255, alpha: 1)
        }
    }
    
    static var gradientColors: [UIColor] {
        get {
            [UIColor.brightSkyBlue, UIColor.skyBlue]
        }
    }
    
}

extension Date {
    static func getDate(fromString date:String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: date)
        return date
    }
    
    var toString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dateStr = dateFormatter.string(from: self)
            return dateStr
        }
    }
    
}

extension UITableView {
    /// Register a XIB file with UITableView
    internal func registerNib(_ nibName: String) {
        let cellNib = UINib.init(nibName: nibName, bundle: nil)
        register(cellNib, forCellReuseIdentifier: nibName)
    }
}

extension UIImageView {
    func setImage(for url: String?, placeholder pImage: UIImage?, completion: @escaping(UIImage?) -> Void) {
        guard let someUrl = url else {
            self.image = pImage
            completion(nil)
            return
        }
        guard let localImage = UIImage(contentsOfFile: self.localPath(for: someUrl)) else {
            guard let someaUrl = URL(string: someUrl) else {
                self.image = pImage
                completion(nil)
                return
            }
            let qos = DispatchQoS(qosClass: .userInitiated, relativePriority: 0)
            DispatchQueue.global(qos: qos.qosClass).async(execute: {
                let imagenData = NSData(contentsOf: someaUrl)
                DispatchQueue.main.async( execute: {
                    imagenData?.write(toFile: self.localPath(for: someUrl), atomically: true)
                    if imagenData != nil{
                        let finalImage = UIImage(data: imagenData! as Data)
                        self.image = finalImage
                        completion(finalImage!)
                    }else{
                        self.image = pImage
                        completion(nil)
                    }
                })
            })
            return
        }
        self.image = localImage
        completion(localImage)
    }
    
    private func fileNeme(for url: String) -> String? {
        if let someUrl = URL(string: url) {
            let pathComponents = someUrl.pathComponents
            
            if pathComponents.count > 1 {
                let last = pathComponents.count - 1
                let seclast = pathComponents.count - 2
                return pathComponents[seclast] + "_" + pathComponents[last]
            }else{
                return someUrl.lastPathComponent
            }
        }
        return nil
    }
    
    private func path(name: String) -> String {
        let finalPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        return finalPath + name
    }
    
    private func localPath(for url: String)-> String {
        let name = fileNeme(for: url)
        guard let someName = name else {
            return ""
        }
        return path(name: someName)
    }
}

/**
Display an alert action in a convenient way. */
public extension UIViewController {
    
    func alert(title: String?, message: String? = nil, buttonTitle: String = "OK") {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in}))
        present(alert, animated: true) {}
    }
    
    func alert(title: String?, message: String? = nil, buttonTitle: String = "OK", completion: @escaping() -> Void) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in
            completion()
        }))
        present(alert, animated: true) {}
    }
    
    func actionSheet(with title: String?, message: String?, completion: @escaping(Int) -> Void) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit Details", style: .default, handler: { (action) in
            completion(0)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Employee", style: .destructive, handler: { (action) in
            completion(1)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completion(2)
        }))
        present(alert, animated: true) {}
    }
    
    
}
 

protocol JsonSerializable {
    init?(json: JsonDictionay )
}

extension JsonSerializable {
    
    ///Create array of items from json
    static func createInstances(from json: JsonDictionay , key:String) -> [Self]? {
        guard let jsonDictionaries = json[key] as? [[String: Any]] else { return nil }
        var array = [Self]()
        for jsonDictionary in jsonDictionaries {
            guard let instance = Self.init(json: jsonDictionary) else { return nil }
            array.append(instance)
        }
        return array
    }
}
