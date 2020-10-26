//
//  RootViewModel.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation

protocol RootViewModelProtocol: class {
    func didPush(completion: (() -> Void)?)
    func didPop(completion: (() -> Void)?)
    func didPresent(completion: (() -> Void)?)
    func didSetAsRoot(completion: (() -> Void)?)
}

// Default imp
extension RootViewModelProtocol {
    func didPush(completion: (() -> Void)?) {
        completion?()
    }
    
    func didPop(completion: (() -> Void)?) {
        completion?()
    }
    
    func didPresent(completion: (() -> Void)?) {
        completion?()
    }
    
    func didSetAsRoot(completion: (() -> Void)?) {
        completion?()
    }
}
