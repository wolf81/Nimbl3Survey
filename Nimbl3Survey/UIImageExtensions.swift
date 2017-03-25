//
//  UIImageExtensions.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func averageColor(alpha: CGFloat) -> UIColor {
        let rawImageRef: CGImage = self.cgImage!
        let data: CFData = rawImageRef.dataProvider!.data!
        let rawPixelData = CFDataGetBytePtr(data);
        
        let imageHeight = rawImageRef.height
        let imageWidth = rawImageRef.width
        let bytesPerRow = rawImageRef.bytesPerRow
        let stride = rawImageRef.bitsPerPixel / 6
        
        var r = 0
        var g = 0
        var b = 0
        
        for row in 0 ... imageHeight {
            var rowPtr = rawPixelData! + bytesPerRow * row
            for _ in 0...imageWidth {
                r += Int(rowPtr[0])
                g += Int(rowPtr[1])
                b += Int(rowPtr[2])
                rowPtr += Int(stride)
            }
        }
        
        let f: CGFloat = 1.0 / (255.0 * CGFloat(imageWidth) * CGFloat(imageHeight))
        
        return UIColor(red: f * CGFloat(r), green: f * CGFloat(g), blue: f * CGFloat(b), alpha: alpha)
    }
}
