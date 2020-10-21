//
//  VDTextKVO.swift
//  VDText
//
//  Created by Harwyn T'an on 2020/10/21.
//

import Foundation

class VDTextKVO: NSObject {
    private func initObserver() {
//        attributedTextObserver = textView.observe(\.attributedText) { [weak self] _, _ in
//            guard let `self` = self else { return }
//            self.placeholderLabel.isHidden = self.attributedText?.length ?? 0 > 0
//        }
//
//        selectedTextRangeObserver = textView.observe(\.selectedTextRange, options: [.new, .old]) { [weak self] _, change in
//            guard let `self` = self else { return }
//            guard let oldSelectedTextRange = change.oldValue!, let newSelectedTextRange = change.newValue! else { return }
//            let newRange = self.convert(selectedTextRange: newSelectedTextRange, to: self.textView)
//            let oldRange = self.convert(selectedTextRange: oldSelectedTextRange, to: self.textView)
//            if newRange.location != oldRange.location {
//                self.textView.attributedText.enumerateAttribute(.vdTextBinding, in: NSRange(location: 0, length: self.textView.attributedText.length), options: .reverse) { attrs, range, _ in
//                    guard attrs != nil else { return }
//                    if (newRange.location > range.location && newRange.location < range.location + range.length) ||
//                        ((newRange.location + newRange.length) < (range.location + range.length) && (newRange.location + newRange.length) > range.location) {
//                        var leftLocation = newRange.location
//                        var rightLocation = newRange.location + newRange.length
//                        if newRange.location > range.location && newRange.location < range.location + range.length {
//                            if newRange.location > range.location + range.length / 2 {
//                                leftLocation = range.location + range.length
//                            } else {
//                                leftLocation = range.location
//                            }
//                        }
//                        if newRange.location + newRange.length < range.location + range.length && newRange.location + newRange.length > range.location {
//                            if newRange.location + newRange.length > range.location + range.length / 2 {
//                                rightLocation = range.location + range.length
//                            } else {
//                                rightLocation = range.location
//                            }
//                        }
//                        self.textView.selectedRange = NSRange(location: leftLocation, length: rightLocation - leftLocation)
//                    }
//                }
//            }
//        }
    }
}
