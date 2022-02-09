//
//  FFyInTexstFontView.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/27.
//

 
import UIKit


class FFyInTexstFontView: UIView {

    var collection: UICollectionView!
    var currentFontStr: String?
    var fontDidSelectBlock: ((String, IndexPath)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
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
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: GCgymFontCell.self)
        
        //
    }

}

extension FFyInTexstFontView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: GCgymFontCell.self, for: indexPath)
        let font =  InCymDataManager.default.textFontList[indexPath.item]
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        cell.fontLabel.fontName(24, font)
           
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InCymDataManager.default.textFontList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension FFyInTexstFontView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension FFyInTexstFontView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = InCymDataManager.default.textFontList[indexPath.item]
        fontDidSelectBlock?(item, indexPath)
        currentFontStr = item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class GCgymFontCell: UICollectionViewCell {
    let fontLabel = UILabel()
    let vipImageV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        //
        fontLabel
            .textAlignment(.center)
            .text("Font")
            .adjustsFontSizeToFitWidth()
            .color(UIColor(hexString: "#000000")!)
            .adhere(toSuperview: contentView)
        fontLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        //
//        vipImageV
//            .image("editor_coin")
//            .contentMode(.scaleAspectFit)
//            .adhere(toSuperview: contentView)
//        vipImageV.snp.makeConstraints {
//            $0.top.right.equalToSuperview()
//            $0.width.height.equalTo(16)
//        }
        
        
    }
}


