//
//  ImageHandle.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/15.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import UIKit
import Kingfisher

class ImageHandle: NSObject {
    var webURL: URL?
    
}

extension ImageHandle: WXImgLoaderProtocol {
    
    @discardableResult
    func downloadImage(withURL url: String!, imageFrame: CGRect, userInfo options: [AnyHashable : Any]! = [:], completed completedBlock: ((UIImage?, Error?, Bool) -> Void)!) -> WXImageOperationProtocol! {
        
        if url.contains("locall") {
            let bindex = url.index(url.startIndex, offsetBy: 9)
            let imgUrl = String(url[bindex..<url.endIndex])
            let image = UIImage(named: imgUrl)
            completedBlock(image, nil, true)
            return ImageOperation(nil)
        } else {
            guard let imageURL = URL(string: url) else { return ImageOperation(nil) }
            let task = KingfisherManager.shared.retrieveImage(with: imageURL, options: KingfisherManager.shared.defaultOptions, progressBlock: nil) { (image, err, _, _) in
                completedBlock(image, err, true)
            }
            return ImageOperation(task)
        }
    }
}

class ImageOperation: NSObject, WXImageOperationProtocol {
    var task: RetrieveImageTask?
    
    init(_ task: RetrieveImageTask?) {
        self.task = task
        super.init()
    }
    
    func cancel() {
        task?.cancel()
    }
}
