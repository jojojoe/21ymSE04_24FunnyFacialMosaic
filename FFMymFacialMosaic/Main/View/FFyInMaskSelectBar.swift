//
//  FFyInMaskSelectBar.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit

class FFyInMaskSelectBar: UIView {

    var backBtnClickBlock: (()->Void)?
    var clearBtnClickBlock: (()->Void)?
    var selectMaskOverlayerItemBlock: ((InCymStickerItem?)->Void)?
    
    var collection: UICollectionView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: "#47D2FF")
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        let backBtn = UIButton()
        backBtn.image("close_ic")
            .adhere(toSuperview: self)
        backBtn.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let saveBtn = UIButton()
        saveBtn.image("edit_done_ic")
            .adhere(toSuperview: self)
        saveBtn.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        saveBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let clearBtn = UIButton()
        clearBtn.image("no_shape_ic")
            .adhere(toSuperview: self)
        clearBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        clearBtn.addTarget(self, action: #selector(clearBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.bottom.right.left.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
        }
        collection.register(cellWithClass: FFyInMaskContentCell.self)
        
    }

}


extension FFyInMaskSelectBar {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func clearBtnClick(sender: UIButton) {
        selectMaskOverlayerItemBlock?(nil)
    }
     
    
    
    
}



extension FFyInMaskSelectBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: FFyInMaskContentCell.self, for: indexPath)
        let item = InCymDataManager.default.maskList[indexPath.item]
        cell.contentImgV.image(item.thumbName)
        if item.isPro == true {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InCymDataManager.default.maskList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension FFyInMaskSelectBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width: CGFloat = 90
        let padding: CGFloat = (UIScreen.width - width * 4 - 1) / 5
        
        
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let width: CGFloat = 90
        let padding: CGFloat = (UIScreen.width - width * 4 - 1) / 5
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let width: CGFloat = 90
        let padding: CGFloat = (UIScreen.width - width * 4 - 1) / 5
        return padding
    }
    
}

extension FFyInMaskSelectBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = InCymDataManager.default.maskList[indexPath.item]
        selectMaskOverlayerItemBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class FFyInMaskContentCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let proImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        //
        proImgV.adhere(toSuperview: contentView)
            .contentMode(.scaleAspectFit)
            .image("coins_small_img")
        proImgV.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
    }
}
