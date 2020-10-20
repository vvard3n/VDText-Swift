//
//  VDTextBinding.swift
//
//  Created by Haijun on 2020/10/19.
//

import Foundation

let kSystemVersion: Double = Double(UIDevice.current.systemVersion) ?? 0

extension NSAttributedString.Key {
    static let vdTextBinding = NSAttributedString.Key("VDTextBinding")
}

extension VDKit where Base: NSAttributedString {
    var color: UIColor? {
        get {
            return color(at: 0)
        }
    }
    var font: UIFont? {
        get {
            return font(at: 0)
        }
    }
    
    fileprivate func font(at index: Int) -> UIFont? {
//        /*
//         In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
//         although Apple does not mention it in documentation.
//
//         In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
//         but UILabel/UITextView cannot use CTFontRef.
//
//         We use UIFont for both CoreText and UIKit.
//         */
//        var font = vd_attribute(NSAttributedString.Key.font, at: index)
//        if (kSystemVersion <= 6) {
//            if font != nil {
//                if CFGetTypeID(font as AnyObject) == CFGetTypeID(CTFont.self) {
//                    let CTFont = font as! CTFont
//                    let name = CTFontCopyPostScriptName(CTFont)
//                    let size = CTFontGetSize(CTFont)
////                    if name == nil {
////                        font = nil
////                    }
////                    else {
//                        font = UIFont(name: name as String, size: size)
////                    }
//                }
//            }
//        }
//        return font as! UIFont?
        
        return attribute(NSAttributedString.Key.font, at: index) as? UIFont ?? nil
    }
    
    fileprivate func color(at index: Int) -> UIColor? {
        var color = attribute(NSAttributedString.Key.foregroundColor, at: index)
        if color == nil {
            if let ref = attribute(kCTForegroundColorAttributeName as NSAttributedString.Key, at: index) {
                color = UIColor(cgColor: ref as! CGColor)
            }
        }
        if color != nil && !(color is UIColor) {
            if CFGetTypeID(color as AnyObject) == CGColor.typeID {
                color = UIColor(cgColor: color as! CGColor)
            }
            else {
                color = nil
            }
        }
        return color as! UIColor?
    }
    
    fileprivate func attribute(_ attrName: NSAttributedString.Key?, at index: Int) -> Any? {
        var index = index
        guard let attrName = attrName else { return nil }
        if (index > base.length || base.length == 0) { return nil }
        if (base.length > 0 && index == base.length) { index -= 1 }
        return base.attribute(attrName, at: index, effectiveRange: nil)
    }
}

extension VDKit where Base: NSMutableAttributedString {
    var color: UIColor? {
        get {
            return color(at: 0)
        }
        set {
            setColor(newValue, range: NSRange(location: 0, length: base.length))
        }
    }
    var font: UIFont? {
        get {
            return font(at: 0)
        }
        set {
            setFont(newValue, range: NSRange(location: 0, length: base.length))
        }
    }
    
    private func setColor(_ color: UIColor?, range: NSRange) {
        setAttribute(.foregroundColor, value: color!, range: range)
    }
    
    private func setFont(_ font: UIFont?, range: NSRange) {
        setAttribute(.font, value: font!, range: range)
    }
    
    private func setAttribute(_ attrName: NSAttributedString.Key?, value: Any, range: NSRange?) {
        guard let attrName = attrName else { return }
        var range = range
        if range == nil {
            range = NSRange(location: 0, length: base.length)
        }
        if !(value is NSNull) {
            base.addAttribute(attrName, value: value, range: range!)
        }
        else {
            base.removeAttribute(attrName, range: range!)
        }
    }
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
