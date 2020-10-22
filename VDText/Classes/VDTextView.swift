//
//  VDTextView.swift
//
//  Created by Harwyn T'an on 2020/10/21.
//

import UIKit

public class VDTextView: UIView {
    public var placeholder: String? {
        didSet { updatePlaceholder() }
    }

    public var placeholderColor: UIColor? {
        didSet { updatePlaceholder() }
    }

    public var placeholderFont: UIFont? {
        didSet { updatePlaceholder() }
    }

    public var font: UIFont? {
        didSet {
            textView.font = font
            updatePlaceholder()
        }
    }

    public var textColor: UIColor? {
        didSet {
            textView.textColor = textColor
        }
    }

    public var text: String? {
        set { textView.text = newValue }
        get { return textView.text }
    }

    public var attributedText: NSAttributedString? {
        set { textView.attributedText = newValue }
        get { return textView.attributedText }
    }

    public var textContainerInset: UIEdgeInsets {
        set { textView.textContainerInset = newValue }
        get { return textView.textContainerInset }
    }

    public var selectedRange: NSRange {
        set { textView.selectedRange = newValue }
        get { return textView.selectedRange }
    }

    public var isScrollEnabled: Bool {
        set { textView.isScrollEnabled = newValue }
        get { textView.isScrollEnabled }
    }

    public var isSelectable: Bool {
        set { textView.isSelectable = newValue }
        get { textView.isSelectable }
    }

    public var typingAttributes: [NSAttributedString.Key: Any] {
        set { textView.typingAttributes = newValue }
        get { textView.typingAttributes }
    }

    private var textView: _TextView = _TextView()
    private var placeholderLabel = UILabel()
    private var attributedTextObserver: NSKeyValueObservation?
    private var selectedTextRangeObserver: NSKeyValueObservation?

    // MARK: - Helpers

    private func convert(selectedTextRange: UITextRange, to textView: UITextView) -> NSRange {
        let beginning = textView.beginningOfDocument
        let start = selectedTextRange.start
        let end = selectedTextRange.end
        let location = textView.offset(from: beginning, to: start)
        let length = textView.offset(from: start, to: end)
        return NSRange(location: location, length: length)
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        var frame = bounds.inset(by: textContainerInset)
        let size = placeholderLabel.sizeThatFits(frame.size)
        frame.origin.x += 3
        frame.size.width = size.width
        frame.size.height = size.height
        placeholderLabel.frame = frame
    }

    // MARK: - UI

    private func updatePlaceholder() {
        placeholderLabel.font = placeholderFont ?? font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.text = placeholder
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
        initObserver()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
        initObserver()
    }

    private func initCommon() {
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.numberOfLines = 0
        addSubview(textView)
        addSubview(placeholderLabel)
        addConstraint(NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }

    // MARK: - KVO

    private func initObserver() {
        attributedTextObserver = textView.observe(\.attributedText) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.placeholderLabel.isHidden = self.attributedText?.length ?? 0 > 0
        }

        selectedTextRangeObserver = textView.observe(\.selectedTextRange, options: [.new, .old]) { [weak self] _, change in
            guard let `self` = self else { return }
            guard let oldSelectedTextRange = change.oldValue!, let newSelectedTextRange = change.newValue! else { return }
            let newRange = self.convert(selectedTextRange: newSelectedTextRange, to: self.textView)
            let oldRange = self.convert(selectedTextRange: oldSelectedTextRange, to: self.textView)
            if newRange.location != oldRange.location {
                self.textView.attributedText.enumerateAttribute(.vdTextBinding, in: NSRange(location: 0, length: self.textView.attributedText.length), options: .reverse) { attrs, range, _ in
                    guard attrs != nil else { return }
                    if (newRange.location > range.location && newRange.location < range.location + range.length) ||
                        ((newRange.location + newRange.length) < (range.location + range.length) && (newRange.location + newRange.length) > range.location) {
                        var leftLocation = newRange.location
                        var rightLocation = newRange.location + newRange.length
                        if newRange.location > range.location && newRange.location < range.location + range.length {
                            if newRange.location > range.location + range.length / 2 {
                                leftLocation = range.location + range.length
                            } else {
                                leftLocation = range.location
                            }
                        }
                        if newRange.location + newRange.length < range.location + range.length && newRange.location + newRange.length > range.location {
                            if newRange.location + newRange.length > range.location + range.length / 2 {
                                rightLocation = range.location + range.length
                            } else {
                                rightLocation = range.location
                            }
                        }
                        self.textView.selectedRange = NSRange(location: leftLocation, length: rightLocation - leftLocation)
                    }
                }
            }
        }
    }
}

extension VDTextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0
    }
}

extension VDTextView {
    func addTextBinding(_ string: String, font: UIFont, color: UIColor) {
        let rawText = textView.attributedText?.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString()
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = self.font
        attributes[.foregroundColor] = textColor
        let value = NSMutableAttributedString(string: " ", attributes: attributes)
        value.append(NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color]))
        value.append(NSAttributedString(string: " ", attributes: attributes))
        value.addAttribute(.vdTextBinding, value: VDTextBinding(deleteConfirm: true), range: NSRange(location: 0, length: value.length))
        let selectedRange = self.selectedRange
        rawText.insert(value, at: selectedRange.location)
        attributedText = rawText
        self.selectedRange = NSRange(location: selectedRange.location + value.length, length: 0)
    }
}

private class _TextView: UITextView {
    private var preSelecteRange: NSRange?
    private var delConform: Bool = false

    override func deleteBackward() {
        if selectedRange.location == 0 {
            delConform = false
            super.deleteBackward()
            return
        }
        var effectiveRange = NSRange(location: 0, length: 0)
        guard attributedText.attribute(.vdTextBinding, at: selectedRange.location - 1, longestEffectiveRange: &effectiveRange, in: NSRange(location: 0, length: attributedText.length)) != nil else {
            delConform = false
            super.deleteBackward()
            return
        }
        let attrbuteString = attributedText.mutableCopy() as! NSMutableAttributedString
        preSelecteRange = selectedRange
        if selectedRange.length > 0 {
            delConform = false
            attrbuteString.replaceCharacters(in: selectedRange, with: "")
            attributedText = attrbuteString
            preSelecteRange = NSRange(location: preSelecteRange?.location ?? 0, length: 0)
            selectedRange = preSelecteRange!
            delegate?.textViewDidChange?(self)
            return
        }

        if !delConform {
            delConform = true
            preSelecteRange = effectiveRange
        }
        else {
            delConform = false
            attrbuteString.replaceCharacters(in: effectiveRange, with: "")
            preSelecteRange = NSRange(location: preSelecteRange?.location ?? 0, length: 0)
//            preSelecteRange = NSRange(location: effectiveRange.location, length: 0) //如果不需要删除前选中，使用这行代码
        }
        attributedText = attrbuteString
        if let range = preSelecteRange { selectedRange = range }
    }
}
