//
//  RRTagController.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

struct Tag {
    var isSelected: Bool
    var isLocked: Bool
    var textContent: String
}

let colorUnselectedTag = UIColor.white
let colorSelectedTag = UIColor(red:0.22, green:0.7, blue:0.99, alpha:1)

let colorTextUnSelectedTag = UIColor(red:0.33, green:0.33, blue:0.35, alpha:1)
let colorTextSelectedTag = UIColor.white

class RRTagController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate var tags = [Tag]()
    fileprivate var navigationBarItem: UINavigationItem!
    fileprivate var leftButton: UIBarButtonItem!
    fileprivate var rigthButton: UIBarButtonItem!
    fileprivate var _totalTagsSelected = 0
    fileprivate let addTagView = RRAddTagView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
    fileprivate var heightKeyboard: CGFloat = 0
    
    var blockFinish: ((_ selectedTags: [Tag], _ unSelectedTags: [Tag]) -> Void)!
    var blockCancel: (() -> Void)!

    var totalTagsSelected: Int {
        get {
            return _totalTagsSelected
        }
        set {
            guard newValue > 0 else {
                _totalTagsSelected = 0
                return
            }
            _totalTagsSelected += newValue
            _totalTagsSelected = _totalTagsSelected < 0 ? 0 : _totalTagsSelected
            navigationBarItem = UINavigationItem(title: "Tags")
            navigationBarItem.leftBarButtonItem = leftButton
            if (_totalTagsSelected == 0) {
                navigationBarItem.rightBarButtonItem = nil
            } else {
                navigationBarItem.rightBarButtonItem = rigthButton
            }
            navigationBar.setItems([navigationBarItem], animated: false)
        }
    }
    
    lazy var collectionTag: UICollectionView = {
        let layoutCollectionView = UICollectionViewFlowLayout()
        layoutCollectionView.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutCollectionView.itemSize = CGSize(width: 90, height: 20)
        layoutCollectionView.minimumLineSpacing = 10
        layoutCollectionView.minimumInteritemSpacing = 5
        let collectionTag = UICollectionView(frame: self.view.frame, collectionViewLayout: layoutCollectionView)
        collectionTag.contentInset = UIEdgeInsets(top: 84, left: 0, bottom: 20, right: 0)
        collectionTag.delegate = self
        collectionTag.dataSource = self
        collectionTag.backgroundColor = .white
        collectionTag.register(RRTagCollectionViewCell.self, forCellWithReuseIdentifier: RRTagCollectionViewCellIdentifier)
        return collectionTag
    }()
    
    lazy var addNewTagCell: RRTagCollectionViewCell = {
        let addNewTagCell = RRTagCollectionViewCell()
        addNewTagCell.contentView.addSubview(addNewTagCell.textContent)
        addNewTagCell.textContent.text = "+"
        addNewTagCell.frame.size = CGSize(width: 40, height: 40)
        addNewTagCell.backgroundColor = UIColor.gray
        return addNewTagCell
    }()
    
    lazy var controlPanelEdition: UIView = {
        let controlPanel = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height + 50, width: UIScreen.main.bounds.size.width, height: 50))
        controlPanel.backgroundColor = .white
        
        let buttonCancel = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 30))
        buttonCancel.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1).cgColor
        buttonCancel.layer.borderWidth = 2
        buttonCancel.backgroundColor = .white
        buttonCancel.setTitle("Cancel", for: UIControlState())
        buttonCancel.setTitleColor(.black, for: UIControlState())
        buttonCancel.titleLabel?.font = .boldSystemFont(ofSize: 17)
        buttonCancel.layer.cornerRadius = 15
        buttonCancel.addTarget(self, action: #selector(RRTagController.cancelEditTag), for: .touchUpInside)

        let buttonAccept = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 110, y: 10, width: 100, height: 30))
        buttonAccept.layer.borderColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1).cgColor
        buttonAccept.layer.borderWidth = 2
        buttonAccept.backgroundColor = .white
        buttonAccept.setTitle("Create", for: UIControlState())
        buttonAccept.setTitleColor(.black, for: UIControlState())
        buttonAccept.titleLabel?.font = .boldSystemFont(ofSize: 17)
        buttonAccept.layer.cornerRadius = 15
        buttonAccept.addTarget(self, action: #selector(RRTagController.createNewTag), for: .touchUpInside)
        
        controlPanel.addSubview(buttonCancel)
        controlPanel.addSubview(buttonAccept)
        return controlPanel
    }()

    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
        
        self.navigationBarItem = UINavigationItem(title: "Tags")
        self.navigationBarItem.leftBarButtonItem = leftButton

        navigationBar.setItems([navigationBarItem], animated: true)
        navigationBar.tintColor = colorSelectedTag
        return navigationBar
    }()
    
    @objc func cancelTagController() {
        self.dismiss(animated: true) {
            self.blockCancel()
        }
    }
    
    @objc func finishTagController() {
        var selected = [Tag]()
        var unSelected = [Tag]()
        
        for currentTag in tags {
            if currentTag.isSelected {
                selected.append(currentTag)
            } else {
                unSelected.append(currentTag)
            }
        }
        self.dismiss(animated: true) {
            self.blockFinish(selected, unSelected)
        }
    }
    
    @objc func cancelEditTag() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [], animations: {
            self.addTagView.frame.origin.y = 0
            self.controlPanelEdition.frame.origin.y = UIScreen.main.bounds.size.height
            self.collectionTag.alpha = 1
        })
    }
    
    @objc func createNewTag() {
        let spaceSet = CharacterSet.whitespaces
        let contentTag = addTagView.textEdit.text.trimmingCharacters(in: spaceSet)
        if strlen(contentTag) > 0 {
            let newTag = Tag(isSelected: false, isLocked: false, textContent: contentTag)
            tags.insert(newTag, at: tags.count)
            collectionTag.reloadData()            
        }
        cancelEditTag()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            if indexPath.row < tags.count {
                return RRTagCollectionViewCell.contentHeight(tags[indexPath.row].textContent)
            }
            return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell: RRTagCollectionViewCell? = collectionView.cellForItem(at: indexPath) as? RRTagCollectionViewCell
        
        if indexPath.row < tags.count {
            if tags[indexPath.row].isSelected == false {
                tags[indexPath.row].isSelected = true
                selectedCell?.animateSelection(tags[indexPath.row].isSelected)
                totalTagsSelected = 1
            }
            else {
                tags[indexPath.row].isSelected = false
                selectedCell?.animateSelection(tags[indexPath.row].isSelected)
                totalTagsSelected = -1
            }
        }
        else {
            addTagView.textEdit.text = nil
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [], animations: {
                self.collectionTag.alpha = 0.3
                self.addTagView.frame.origin.y = 64
            }, completion: { _ in
                self.addTagView.textEdit.becomeFirstResponder()
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RRTagCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: RRTagCollectionViewCellIdentifier, for: indexPath) as? RRTagCollectionViewCell
        
        if indexPath.row < tags.count {
            let currentTag = tags[indexPath.row]
            cell?.initContent(currentTag)
        } else {
            cell?.initAddButtonContent()
        }
        return cell!
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // TODO: change value
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                heightKeyboard = keyboardSize.height
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [], animations: {
                    self.controlPanelEdition.frame.origin.y = self.view.frame.size.height - self.heightKeyboard - 50
                })
            }
        }
        else {
            heightKeyboard = 0
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        heightKeyboard = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        leftButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(RRTagController.cancelTagController))
        rigthButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(RRTagController.finishTagController))
        
        totalTagsSelected = 0
        self.view.addSubview(collectionTag)
        self.view.addSubview(addTagView)
        self.view.addSubview(controlPanelEdition)
        self.view.addSubview(navigationBar)
        NotificationCenter.default.addObserver(self, selector: #selector(RRTagController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RRTagController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    class func displayTagController(_ parentController: UIViewController, _ tagsString: [String]?,
        blockFinish: @escaping (_ selectedTags: [Tag], _ unSelectedTags: [Tag]) -> Void, blockCancel: @escaping () -> Void) {
        let tagController = RRTagController()
        tagController.tags = []
        if tagsString != nil {
            for currentTag in tagsString! {
                tagController.tags.append(Tag(isSelected: false, isLocked: false, textContent: currentTag))
            }
        }
        tagController.blockCancel = blockCancel
        tagController.blockFinish = blockFinish
        parentController.present(tagController, animated: true, completion: nil)
    }

    class func displayTagController(_ parentController: UIViewController, _ tags: [Tag]?,
        blockFinish: @escaping (_ selectedTags: [Tag], _ unSelectedTags: [Tag]) -> Void, blockCancel: @escaping () -> Void) {
        let tagController = RRTagController()
        tagController.tags = tags ?? []
        tagController.blockCancel = blockCancel
        tagController.blockFinish = blockFinish
        parentController.present(tagController, animated: true, completion: nil)
    }
    
}
