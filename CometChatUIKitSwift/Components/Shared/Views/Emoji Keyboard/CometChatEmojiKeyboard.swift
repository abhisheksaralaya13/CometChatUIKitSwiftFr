//
//  CometChatEmojiKeyboard.swift
 
//
//  Created by Abdullah Ansari on 08/06/22.
//

import UIKit
import CometChatSDK

protocol CometChatEmojiKeyboardPresentable {
   var string: String { get }
   var rowVC: UIViewController & PanModalPresentable { get }
}


public class CometChatEmojiKeyboard: UIViewController, PanModalPresentable {
    
    // MARK: - Pan Model Presentable.
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    @IBOutlet weak var emojiSetCollectionView: UICollectionView!
    var onClick: ((_ emoji: CometChatEmoji) -> Void)?
    var hideSearch: Bool?
    var emojiKeyboardStyle: EmojiKeyboardStyle?
    var selectedEmojiSetCategoryIndex: Int = 0
    
    
    var panScrollable: UIScrollView?
    var shortFormHeight: PanModalHeight {
        return .contentHeight(CGFloat(400.0))
    }
    var emojiCategories: [CometChatEmojiCategory] = []
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchEmojis()
    }

    public override func loadView() {
        let loadedNib = CometChatUIKit.bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        if let contentView = loadedNib?.first as? UIView  {
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.backgroundColor = CometChatTheme.palatte.background
            self.view = contentView
            self.view.backgroundColor = CometChatTheme.palatte.background
            self.header.textColor = CometChatTheme.palatte.accent
            self.cancel.setTitleColor(CometChatTheme.palatte.primary, for: .normal)
        }
    }
    
    private func setupCollectionView() {
        emojiCollectionView.backgroundColor = CometChatTheme.palatte.background
        emojiSetCollectionView.backgroundColor = CometChatTheme.palatte.background
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        emojiSetCollectionView.delegate = self
        emojiSetCollectionView.dataSource = self
        let headerNib = UINib(nibName: "CometChatEmojiHeader", bundle: CometChatUIKit.bundle)
        emojiCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CometChatEmojiHeader.identifier)
        let nib = UINib(nibName: "CometChatEmojiKeyboardItem", bundle: CometChatUIKit.bundle)
        emojiCollectionView.register(nib, forCellWithReuseIdentifier: CometChatEmojiKeyboardItem.idetifier)
        emojiSetCollectionView.register(nib, forCellWithReuseIdentifier: CometChatEmojiKeyboardItem.idetifier)
       
    }

    @discardableResult
    public func setOnClick(onClick: @escaping ((_ emoji: CometChatEmoji) -> Void)) -> Self {
        self.onClick = onClick
        return self
    }
    
    private func fetchEmojis() {
        
        CometChatEmojiCategoryJSON.getEmojis { [weak self] data in
            guard let strongSelf = self else { return }
            do {
                strongSelf.emojiCategories = try JSONDecoder().decode(CometChatEmojiCategories.self, from: data).emojiCategory
                DispatchQueue.main.async {
                    strongSelf.emojiCollectionView.reloadData()
                    strongSelf.emojiSetCollectionView.reloadData()
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func onCancelClick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension CometChatEmojiKeyboard: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == emojiCollectionView {
            return emojiCategories.count
        }
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojiCategories[section].emojis.count
        }
        return emojiCategories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CometChatEmojiKeyboardItem.idetifier, for: indexPath) as! CometChatEmojiKeyboardItem
            cell.emojiIcon.image = emojiCategories[indexPath.section].emojis[indexPath.row].emoji.textToImage()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CometChatEmojiKeyboardItem.idetifier, for: indexPath) as! CometChatEmojiKeyboardItem
        
        cell.emojiIcon.image =   UIImage(named: emojiCategories[indexPath.row].symbol, in: CometChatUIKit.bundle, compatibleWith: nil)
        
        if indexPath.row == selectedEmojiSetCategoryIndex {
            cell.emojiIcon.tintColor = CometChatTheme.palatte.primary
        } else {
            cell.emojiIcon.tintColor = CometChatTheme.palatte.accent600
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            onClick?(emojiCategories[indexPath.section].emojis[indexPath.row])
            self.dismiss(animated: true)
        } else if collectionView == emojiSetCollectionView {
            let index = IndexPath(row: emojiCategories.count - 1, section: indexPath.row)
            emojiCollectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
            self.selectedEmojiSetCategoryIndex = indexPath.row
            self.emojiSetCollectionView.reloadData()
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emojiCollectionView {
            return CGSize(width: 30, height: 30)
        }
        return CGSize(width: UIScreen.main.bounds.width / 8 * 0.75, height: 24)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == emojiCollectionView {
            return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        }
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == emojiCollectionView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CometChatEmojiHeader.identifier, for: indexPath) as! CometChatEmojiHeader
                headerView.category.text = emojiCategories[indexPath.section].name
                return headerView
            default:
                print("Either footer or default.")
            }
        }
        return UICollectionReusableView(frame: .zero)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == emojiCollectionView {
            return CGSize(width: emojiCollectionView.frame.width, height: 30)
        }
        return CGSize()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            self.emojiSetCollectionView.scrollToItem(at: IndexPath(row: indexPath.section, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == emojiCollectionView {
            let visibleIndexPaths = emojiCollectionView.indexPathsForVisibleItems
            let sortedIndexPaths = visibleIndexPaths.sorted { $0.item < $1.item }
            let topVisibleIndexPath = sortedIndexPaths.first
            if let topIndexPath = topVisibleIndexPath,
               let emojiSetCollectionViewCell = emojiSetCollectionView.cellForItem(at: IndexPath(row: topIndexPath.section, section: 0)) as? CometChatEmojiKeyboardItem {
                emojiSetCollectionViewCell.emojiIcon.tintColor = CometChatTheme.palatte.primary
                self.selectedEmojiSetCategoryIndex =  topIndexPath.section
                self.emojiSetCollectionView.reloadData()
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

// TODO: - This extension should be in separate file.
extension String {
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 30) // font.
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) // begin image context.
        UIColor.clear.set() // clear background
        
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect.
        
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
