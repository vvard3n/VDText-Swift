//
//  VDTextBinding.swift
//
//  Created by Haijun on 2020/10/19.
//

import Foundation

extension NSAttributedString.Key {
    static let vdTextBinding = NSAttributedString.Key("VDTextBinding")
}

class VDTextBinding: NSObject, NSCoding, NSCopying {
    var deleteConfirm: Bool

    init(deleteConfirm: Bool) {
        self.deleteConfirm = deleteConfirm
    }

    func encode(with coder: NSCoder) {
        coder.encode(deleteConfirm, forKey: "deleteConfirm")
    }

    required init?(coder: NSCoder) {
        deleteConfirm = coder.decodeBool(forKey: "deleteConfirm")
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return VDTextBinding(deleteConfirm: deleteConfirm)
    }
}
