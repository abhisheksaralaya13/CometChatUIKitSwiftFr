//  CometChatAvatar.swift
 
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2022 CometChat Inc. All rights reserved.

/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
 CometChatAvatar: This component will be the class of UIImageView which is customizable to display CometChatAvatar.
 
 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  */


// MARK: - Importing Frameworks.

import Foundation
import  UIKit
import AVFAudio


/*  ----------------------------------------------------------------------------------------- */

@IBDesignable
@objc public class CometChatAvatar: UIImageView {
    
    // MARK: - Declaration of IBInspectable
    let context = UIGraphicsGetCurrentContext()
    var rectangle : CGRect?
    
    @IBInspectable var setOuterView: Bool = false
    var cornerRadius: CometChatCornerStyle?
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.5
    @IBInspectable var setBackgroundColor: UIColor = CometChatTheme.palatte.accent500
    @IBInspectable var setFont: UIFont = CometChatTheme.typography.name
    @IBInspectable var setFontColor: UIColor = .white
    
    
    // MARK: - Initialization of required Methods
    override init(image: UIImage?) { super.init(image: image) }
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    // MARK: - Variable declaration.
    private var avatarURL: String?
    private var name: String?
    private var imageRequest: Cancellable?
    private lazy var imageService = ImageService()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = setBackgroundColor
        if let cornerRadius = cornerRadius, cornerRadius.cornerRadius != -1 {
            self.layer.cornerRadius = cornerRadius.cornerRadius
        } else {
            self.layer.cornerRadius = self.bounds.width / 2
        }
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.tintColor = setBackgroundColor
        setAvatar(avatarUrl: avatarURL, with: name)
    }
    // MARK: - instance methods
    
    /**
     This method used to set the cornerRadius for CometChatAvatar class
     - Parameter cornerRadius: This specifies a float value  which sets corner radius.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [CometChatAvatar Documentation](https://prodocs.cometchat.com/docs/ios-ui-components#section-1-avatar)
     */
    @discardableResult
    public func set(cornerRadius : CometChatCornerStyle) -> CometChatAvatar {
        self.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.setNeedsLayout()
        return self
    }
    
    /**
     This method used to set the borderColor for CometChatAvatar class
     - Parameter borderColor: This specifies a `UIColor` for border of the CometChatAvatar.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [CometChatAvatar Documentation](https://prodocs.cometchat.com/docs/ios-ui-components#section-1-avatar)
     */
    @discardableResult
    @objc public func set(borderColor : UIColor) -> CometChatAvatar {
        self.borderColor = borderColor
        self.setNeedsLayout()
        return self
    }
    
    @discardableResult
    @objc public func set(font : UIFont) -> CometChatAvatar {
        self.setFont = font
        self.setNeedsLayout()
        return self
    }
    
    @discardableResult
    @objc public func set(fontColor: UIColor) -> CometChatAvatar {
        self.setFontColor = fontColor
        self.setNeedsLayout()
        return self
    }
    
    
    /**
     This method used to set the backgroundColor for Avatar class
     - Parameter borderColor: This specifies a `UIColor` for border of the Avatar.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [Avatar Documentation](https://prodocs.cometchat.com/docs/ios-ui-components#section-1-avatar)
     */
    @discardableResult
    @objc public func set(backgroundColor : UIColor) -> CometChatAvatar {
        self.setBackgroundColor = backgroundColor
        self.setNeedsLayout()
        return self
    }
    
    /**
     This method used to set the borderWidth for CometChatAvatar class
     - Parameter borderWidth: This specifies a `CGFloat` for border width of the CometChatAvatar.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [Avatar Documentation](https://prodocs.cometchat.com/docs/ios-ui-components#section-1-avatar)
     */
    @discardableResult
    @objc public func set(borderWidth : CGFloat) -> CometChatAvatar {
        self.borderWidth = borderWidth
        self.setNeedsLayout()
        return self
    }
    
    
    /**
     This method used to set the image for CometChatAvatar class
     - Parameter image: This specifies a `URL` for  the CometChatAvatar.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [Avatar Documentation](https://prodocs.cometchat.com/docs/ios-ui-components#section-1-avatar)
     */
    @discardableResult
    @objc public func setAvatar(avatarUrl: String) -> CometChatAvatar {
        self.avatarURL = avatarUrl
        guard let url = URL(string: avatarUrl) else { return self }
        imageRequest = imageService.image(for: url) { [weak self] image in
            guard let strongSelf = self else { return }
            // Update Thumbnail Image View
            if let image = image {
                strongSelf.image = image
            } else {
                strongSelf.image = UIImage(named: "defaultAvatar.jpg", in: CometChatUIKit.bundle , compatibleWith: nil)
            }
        }
        self.set(outerView: setOuterView)
        return self
    }
    
    @discardableResult
    public func setAvatar(avatarUrl: String?, with name: String?) -> CometChatAvatar {
        self.avatarURL = avatarUrl
        self.name = name
        guard  let url = URL(string: avatarUrl ?? "") else {
            setImage(string: name?.uppercased(), color: setBackgroundColor, textAttributes: [ NSAttributedString.Key.font: setFont, NSAttributedString.Key.foregroundColor: setFontColor])
            return self
        }
        imageRequest = imageService.image(for: url) { [weak self] image in
            guard let strongSelf = self else { return }
            // Update Thumbnail Image View
            if let image = image {
                strongSelf.image = image
             } else {
                
                strongSelf.setImage(string: name?.uppercased(), color: strongSelf.setBackgroundColor, textAttributes: [ NSAttributedString.Key.font: strongSelf.setFont, NSAttributedString.Key.foregroundColor: strongSelf.setFontColor])
            }
        }
        set(outerView: setOuterView)
        return self
    }
    
    @discardableResult
    public func set(outerView: Bool) -> CometChatAvatar {
        if outerView == true {
            self.layer.borderWidth = 5.0
            self.layer.borderColor = setBackgroundColor.cgColor
            self.layer.cornerRadius = self.frame.width / 2
            
            let borderLayer = CALayer()
            borderLayer.frame = self.bounds
            borderLayer.borderColor = UIColor.white.cgColor
            borderLayer.borderWidth = 5
            borderLayer.cornerRadius = borderLayer.frame.width / 2
            self.layer.insertSublayer(borderLayer, above: self.layer)
        }
        return self
    }

    public func cancel() {
        /// This method will cancel the request.
        imageRequest?.cancel()
    }
    
    public func set(configuration: AvatarConfiguration?) {
        
    }
    
//    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        layoutSubviews()
//    }
}

/*  ----------------------------------------------------------------------------------------- */

