//
//  ViewController.swift
//  VDText
//
//  Created by vvard3n@gmail.com on 10/20/2020.
//  Copyright (c) 2020 vvard3n@gmail.com. All rights reserved.
//

import UIKit
import VDText

class ViewController: UIViewController {

    @IBOutlet weak var textView: VDTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addLinkBtnDIdClick(_ sender: UIButton) {
//        NSMutableAttributedString *mattStr = self.textEditor.attributedText.mutableCopy;
        let mattStr = textView.attributedText?.mutableCopy()
        let replaceText = NSMutableAttributedString(string: " ")
//        replaceText.vd
        //替换文本
//        NSMutableAttributedString *replaceText = [[NSMutableAttributedString alloc] initWithString:@" "];
//        replaceText.vd_color = kTextViewTextColor;
//        replaceText.vd_font = kTextViewFontSize;
//        NSMutableAttributedString *displayName = [[NSMutableAttributedString alloc] initWithString:@"高亮链接"];
//        displayName.vd_color = HIGHLIGHT_BLUE_COLOR;
//        displayName.vd_font = kTextViewFontSize;
//        [replaceText appendAttributedString:displayName];
//        NSMutableAttributedString *blackSpace = [[NSMutableAttributedString alloc] initWithString:@" "];
//        blackSpace.vd_color = kTextViewTextColor;
//        blackSpace.vd_font = kTextViewFontSize;
//        [replaceText appendAttributedString:blackSpace];
//        [replaceText vd_setTextBinding:[VDTextBinding bindingWithDeleteConfirm:YES] range:NSMakeRange(0, replaceText.length)];
//
//
//        [replaceText vd_setTextHighlightRange:NSMakeRange(1, replaceText.length - 2) color:HIGHLIGHT_BLUE_COLOR backgroundColor:nil userInfo:@{@"type" : @"url", @"text" : @"anyText"}];
//
//        // 添加被替换的原始字符串，用于复制
//        VDTextBackedString *backed = [VDTextBackedString stringWithString:@"高亮链接"];
//        [replaceText vd_setTextBackedString:backed range:NSMakeRange(0, replaceText.length)];
//
//        NSRange selectedRange = self.textEditor.selectedRange;
//        [mattStr insertAttributedString:replaceText atIndex:selectedRange.location];
//        [mattStr addAttributes:@{NSForegroundColorAttributeName:HIGHLIGHT_BLUE_COLOR, NSFontAttributeName:kTextViewFontSize} range:selectedRange];
//
//        self.textEditor.attributedText = mattStr.copy;
//
//        self.textEditor.selectedRange = NSMakeRange(selectedRange.location + replaceText.length, 0);
    }
}

