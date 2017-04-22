//
//  ActionListener.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/15.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

/// El Capitan以前はaction targetがNSObjectを継承していなければならないため、targetとして利用する
///
/// extension ActionListener {
///     @IBAction func action(_ sender: Any?) {
///         guard let owner = owner as? Responder? else { return }
///         owner.operate()
///     }
/// }
///
/// class Responder {
///     let listener = ActionListener()
///     let actionSender: AnyObject
///
///     init() {
///         actionSender.action = #selector(ActionListener.action(_:))
///         actionSender.target = listener
///         listener.owner = self
///     }
///     func operate() {
///         // do something
///     }
/// }
class ActionListener: NSObject {
    weak var owner: AnyObject?
}
