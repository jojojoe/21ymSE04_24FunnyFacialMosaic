//
//  FFyInTexstColorView.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/27.
//

import UIKit


import UIKit

class FFyInTexstColorView: UIView {

    //
    var collection: UICollectionView!
    
    var borderColorList: [String] = []
    var colorDidSelectBlock: ((String, IndexPath)->Void)?
    var currentColorS: String?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderColorList = InCymDataManager.default.textColorList
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalTo(70)
            $0.centerY.equalToSuperview()
        }
        collection.register(cellWithClass: MSmsyColorCell.self)
        
    }
    

}


extension FFyInTexstColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MSmsyColorCell.self, for: indexPath)
        let colorS = borderColorList[indexPath.item]
        
        
        
        
        if colorS.contains("#") {
            cell.contentImgV.image = UIImage(named: "lamb_love_color_img")?.withRenderingMode(.alwaysTemplate)
            cell.contentImgV.tintColor(UIColor(hexString: colorS) ?? UIColor.clear)
//            cell.contentImgV.backgroundColor(UIColor(hexString: colorS) ?? UIColor.clear)
        } else {
            cell.contentImgV.backgroundColor(.clear)
            cell.contentImgV.image(colorS)
        }
        //
//        if colorS.contains("FFFFFF") {
//            cell.contentImgV.layer.borderWidth = 1
//            cell.contentImgV.layer.borderColor = UIColor.lightGray.cgColor
//        } else {
//            cell.contentImgV.layer.borderWidth = 0
//        }
        //
//        if currentColorS == colorS {
//            cell.selectV.isHidden = false
//        } else {
//            cell.selectV.isHidden = true
//        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return borderColorList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension FFyInTexstColorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}

extension FFyInTexstColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorS = borderColorList[indexPath.item]
        colorDidSelectBlock?(colorS, indexPath)
        
        //
        currentColorS = colorS
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class MSmsyColorCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        //
        
        selectV
            .image("editor_check")
            .adhere(toSuperview: contentView)
        selectV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
    }
}

