//
//  FFyInDataManager.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import GPUImage
import Foundation
import SwifterSwift
import UIKit

 
struct InCymStickerItem: Codable {
    var thumbName: String?
    var bigName: String?
    var isPro: Bool?
    
}

class GCFilterItem: Codable {

    let filterName : String
    let type : String
    let imageName : String
    
    enum CodingKeys: String, CodingKey {
        case filterName
        case type
        case imageName
    }
    
}

class InCymDataManager: NSObject {
    static let `default` = InCymDataManager()
    
    var scrollPositionIsRightToLeft: Bool = true
    
    var filterList : [GCFilterItem] {
        return InCymDataManager.default.loadPlist([GCFilterItem].self, name: "FilterList") ?? []
    }
    
    var overlayerList : [InCymStickerItem] {
        return InCymDataManager.default.loadJson([InCymStickerItem].self, name: "overlayer") ?? []
    }
     
    var maskList : [InCymStickerItem] {
        return InCymDataManager.default.loadJson([InCymStickerItem].self, name: "mask") ?? []
    }
    
    
    var textColorList: [String] {
        return ["#FFFFFF", "#000000", "#FF6A00", "#F2EBE6", "#EA2F2F", "#FF922D", "#FFE000", "#59D045", "#06BEF9", "#427FFF", "#7E51FF", "#FF399C"]
    }
    
    var textFontList: [String] = ["AvenirNext-Medium", "Chalkboard SE", "Courier", "Futura", "Gill Sans", "Marker Felt", "Baskerville", "Chalkduster",  "Menlo", "Noteworthy", "Papyrus", "Savoye Let"]
      
    var paidFontList: [String] = ["Chalkduster", "Chalkboard SE", "Courier", "Futura", "Gill Sans", "Marker Felt", "Menlo", "Noteworthy", "Papyrus", "Savoye Let"]
    
    
    
    
    
    override init() {
        super.init()
         
        
    }
     
    
}

extension InCymDataManager {
    
}


extension InCymDataManager {
    func loadJson<T: Codable>(_: T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



public func MyColorFunc(_ red:CGFloat,_ gren:CGFloat,_ blue:CGFloat,_ alpha:CGFloat) -> UIColor? {
    let color:UIColor = UIColor(red: red/255.0, green: gren/255.0, blue: blue/255.0, alpha: alpha)
    return color
}

// filter
extension InCymDataManager {
    func filterOriginalImage(image: UIImage, lookupImgNameStr: String) -> UIImage? {
        
        if let gpuPic = GPUImagePicture(image: image), let lookupImg = UIImage(named: lookupImgNameStr), let lookupPicture = GPUImagePicture(image: lookupImg) {
            let lookupFilter = GPUImageLookupFilter()
            
            gpuPic.addTarget(lookupFilter, atTextureLocation: 0)
            lookupPicture.addTarget(lookupFilter, atTextureLocation: 1)
            lookupFilter.intensity = 0.7
            
            lookupPicture.processImage()
            gpuPic.processImage()
            lookupFilter.useNextFrameForImageCapture()
            let processedImage = lookupFilter.imageFromCurrentFramebuffer()
            return processedImage
        } else {
            return nil
        }
        return nil
    }
}


