//
//  extensionUIView.swift
//  ChessClock
//
//  Created by Aaron Green on 7/12/16.
//  Copyright © 2016 Aaron Green. All rights reserved.
//

import UIKit

extension UIView {
    func addBackground () {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
    
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "darkKing.jpg")
    
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill

        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}

