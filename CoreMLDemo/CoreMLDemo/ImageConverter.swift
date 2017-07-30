//
//  ImageConverter.swift
//  CoreMLDemo
//
//  Created by Hugo Peregrina Sosa on 7/28/17.
//  Copyright © 2017 Wizeline. All rights reserved.
//

import UIKit

class ImageConverter: NSObject {
    public static let shared = ImageConverter()
    var imageBuffer: CVPixelBuffer?

    func processImage(image: UIImage) -> UIImage? {
        //Crop the image to the required 299x299 size
        guard let cropped = cropImage(image: image) else { return nil }
        return convertToPixelBuffer(image: cropped)
    }
    
    func getImagePixelBuffer() -> CVPixelBuffer? {
        return imageBuffer
    }
    
    private func cropImage(image: UIImage) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        guard let cropped = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return cropped
    }
    
   private  func convertToPixelBuffer(image: UIImage) -> UIImage {
        var newImage = UIImage()
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else { return newImage }
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        self.imageBuffer = pixelBuffer
        newImage = image
        return newImage
    }
    
}
