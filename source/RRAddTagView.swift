//
//  RRAddTagView.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

public class RRAddTagView: UIView, UITextViewDelegate {

    public lazy var title: UILabel = {
        let title = UILabel(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.size.width - 20, height: 20))
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = NSTextAlignment.center
        return title
    }()

    public lazy var textEdit: UITextView = {
        let textEdit = UITextView(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.size.width - 20, height: 20))
        textEdit.delegate = self
        return textEdit
    }()
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if strlen(textView.text) + strlen(text) > 44 {
            return false
        }
        return true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        title.text = "Create a new tag."
        self.addSubview(title)
        self.addSubview(textEdit)
        self.backgroundColor = UIColor.white
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
