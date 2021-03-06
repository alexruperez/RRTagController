//
//  RRTagCollectionViewCell.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

let RRTagCollectionViewCellIdentifier = "RRTagCollectionViewCellIdentifier"

public class RRTagCollectionViewCell: UICollectionViewCell {
    
    public var cellSelected: Bool = false

    fileprivate var colorUnselectedTag: UIColor!
    fileprivate var colorSelectedTag: UIColor!
    fileprivate var colorTextUnSelectedTag: UIColor!
    fileprivate var colorTextSelectedTag: UIColor!
    
    public lazy var textContent: UILabel! = {
        let textContent = UILabel(frame: CGRect.zero)
        textContent.layer.masksToBounds = true
        textContent.layer.cornerRadius = 20
        textContent.layer.borderWidth = 2
        textContent.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1).cgColor
        textContent.font = UIFont.boldSystemFont(ofSize: 17)
        textContent.textAlignment = NSTextAlignment.center
        return textContent
    }()
    
    public func initContent(_ tag: Tag, colorUnselectedTag: UIColor, colorSelectedTag: UIColor, colorTextUnSelectedTag: UIColor, colorTextSelectedTag: UIColor) {
        self.colorUnselectedTag = colorUnselectedTag
        self.colorSelectedTag = colorSelectedTag
        self.colorTextUnSelectedTag = colorTextUnSelectedTag
        self.colorTextSelectedTag = colorTextSelectedTag
        self.contentView.addSubview(textContent)
        textContent.text = tag.textContent
        textContent.sizeToFit()
        textContent.frame.size.width = textContent.frame.size.width + 30
        textContent.frame.size.height = textContent.frame.size.height + 20
        cellSelected = tag.isSelected
        textContent.backgroundColor = UIColor.clear
        self.textContent.layer.backgroundColor = (cellSelected == true) ? colorSelectedTag.cgColor : colorUnselectedTag.cgColor
        self.textContent.textColor = (cellSelected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
    }
    
    public func initAddButtonContent() {
        self.contentView.addSubview(textContent)
        textContent.text = "+"
        textContent.sizeToFit()
        textContent.frame.size = CGSize(width: 40, height: 40)
        textContent.backgroundColor = UIColor.clear
        self.textContent.layer.backgroundColor = UIColor.gray.cgColor
        self.textContent.textColor = UIColor.white
    }
    
    public func animateSelection(_ selection: Bool) {
        cellSelected = selection
    
        self.textContent.frame.size = CGSize(width: self.textContent.frame.size.width - 20, height: self.textContent.frame.size.height - 20)
        self.textContent.frame.origin = CGPoint(x: self.textContent.frame.origin.x + 10, y: self.textContent.frame.origin.y + 10)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: [], animations: { () -> Void in
            self.textContent.layer.backgroundColor = (self.cellSelected == true) ? self.colorSelectedTag.cgColor : self.colorUnselectedTag.cgColor
            self.textContent.textColor = (self.cellSelected == true) ? self.colorTextSelectedTag : self.colorTextUnSelectedTag
            self.textContent.frame.size = CGSize(width: self.textContent.frame.size.width + 20, height: self.textContent.frame.size.height + 20)
            self.textContent.center = CGPoint(x: self.contentView.frame.size.width / 2, y: self.contentView.frame.size.height / 2)
        }, completion: nil)
    }
    
    public class func contentHeight(_ content: String) -> CGSize {
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.center
        let attributs = [NSAttributedStringKey.paragraphStyle:styleText, NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 17)]
        let sizeBoundsContent = (content as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributs, context: nil)
        return CGSize(width: sizeBoundsContent.width + 30, height: sizeBoundsContent.height + 20)
    }
}

