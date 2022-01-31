//
//  ScaledHeightImageView.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation
import SDWebImage

class ScaledHeightImageView: UIImageView
{
    override var intrinsicContentSize: CGSize
    {
        if let myImage = self.image
        {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
     
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
    
    func setImage(image: UIImage?, completion: (() -> Void)? = nil)
    {
        self.image = image
        invalidateIntrinsicContentSize()
        completion?()
    }
    
    func setImage(urlString: String?, placeholderImage: UIImage? = nil, completion: (() -> Void)? = nil)
    {
        setImage(image: placeholderImage)
        sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: placeholderImage) { (image, error, type, url) in
            self.setImage(image: image, completion: completion)
        }
    }
}
