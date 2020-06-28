//
//  NewsCell.swift
//  TV News
//
//  Created by Dixita Bhargava on 28/06/20.
//  Copyright © 2020 Dixita Bhargava. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: RemoteImageView!
    
    @IBOutlet var unfocusedConstraint: NSLayoutConstraint!
    
    var focusedConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        focusedConstraint = textLabel.topAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor, constant: 15)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        focusedConstraint.isActive = isFocused
        unfocusedConstraint.isActive = !isFocused
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        setNeedsUpdateConstraints()
        
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        })
    }
}
