//
//  VDTextBinding.swift
//
//  Created by Harwyn T'an on 2020/10/21.
//

import Foundation

let kSystemVersion: Double = Double(UIDevice.current.systemVersion) ?? 0

//var VDTextAction: ((_ containerView: UIView?, _ text: NSAttributedString?, _ range: NSRange, _ rect: CGRect)->())?

public typealias VDTextAction = ((_ containerView: UIView?, _ text: NSAttributedString?, _ range: NSRange, _ rect: CGRect)->())?

extension NSAttributedString.Key {
    static let vdTextBinding = NSAttributedString.Key("VDTextBinding")
    static let vdTextHighlight = NSAttributedString.Key("VDTextHighlight")
    static let vdTextBackedString = NSAttributedString.Key("VDTextBackedString")
}

extension VDKit where Base: NSAttributedString {
    public var color: UIColor? {
        get {
            return color(at: 0)
        }
    }
    public var font: UIFont? {
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
    public var color: UIColor? {
        get {
            return color(at: 0)
        }
        set {
            setColor(newValue, range: NSRange(location: 0, length: base.length))
        }
    }
    public var font: UIFont? {
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
    
    public func setTextBinding(_ textBinding: VDTextBinding, range: NSRange) {
        setAttribute(NSAttributedString.Key.vdTextBinding, value: textBinding, range: range)
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

/**
VDTextBinding objects are used by the NSAttributedString class cluster
as the values for shadow attributes (stored in the attributed string under
the key named VDTextBindingAttributeName).

Add this to a range of text will make the specified characters 'binding together'.
VDTextView will treat the range of text as a single character during text
selection and edit.
*/
public class VDTextBinding: NSObject, NSCoding, NSCopying {
    public var deleteConfirm: Bool

    public init(deleteConfirm: Bool) {
        self.deleteConfirm = deleteConfirm
    }

    public func encode(with coder: NSCoder) {
        coder.encode(deleteConfirm, forKey: "deleteConfirm")
    }

    required public init?(coder: NSCoder) {
        deleteConfirm = coder.decodeBool(forKey: "deleteConfirm")
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        return VDTextBinding(deleteConfirm: deleteConfirm)
    }
}

public class VDTextHighlight: NSObject, NSCoding, NSCopying {
    /**
     Attributes that you can apply to text in an attributed string when highlight.
     Key:   Same as CoreText/VDText Attribute Name.
     Value: Modify attribute value when highlight (NSNull for remove attribute).
     */
    public var attributes: [String : Any]?
    
    /**
     The user information dictionary, default is nil.
     */
    public var userInfo: [String : Any]?
    
    /**
     Tap action when user tap the highlight, default is nil.
     If the value is nil, VDTextView or VDLabel will ask it's delegate to handle the tap action.
     */
    public var longPressAction: VDTextAction?
    
    /**
     Long press action when user long press the highlight, default is nil.
     If the value is nil, VDTextView or VDLabel will ask it's delegate to handle the long press action.
     */
    public var tapAction: VDTextAction?
    
    public func encode(with coder: NSCoder) {
        coder.encode(attributes, forKey: "attributes")
    }
    
    public required init?(coder: NSCoder) {
        if let obj = coder.decodeObject(forKey: "attributes") as? [String : Any]? {
            attributes = obj
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let one = VDTextHighlight()
        one.attributes = attributes
        return one
    }
    
//    public class func highlightWithAttributes(attributes: [String : Any]?) -> VDTextHighlight {
//        
//    }
    
    override init() {
        
    }
    
    convenience init(attributes: [String : Any]?) {
        self.init()
        self.attributes = attributes
    }
    
//    convenience init(backgroundColor: UIColor?) {
//        self.init()
//
//    }
    
//    convenience init(attributes: [String : Any]?, asdf:Bool) {
//        self.init
//    }
}
