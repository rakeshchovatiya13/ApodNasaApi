//
//  ApodVideoTableViewCell.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 30/01/22.
//

import AVFoundation
import UIKit

class ApodVideoTableViewCell: ApodTableViewCell
{
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String?
    {
        didSet
        {
            if let videoURL = videoURL
            {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        /// Setup  video layer
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        /// Add video layer in imageview to play video on thumb imageview
        apodImageView.layer.addSublayer(videoLayer)
    }
    
    override func configureCell(from apodData: ApodInfoBean?)
    {
        super.configureCell(from: apodData)
        self.videoURL = apodData?.url
    }
    
    func visibleVideoHeight() -> CGFloat
    {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(apodImageView.frame, from: apodImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}
