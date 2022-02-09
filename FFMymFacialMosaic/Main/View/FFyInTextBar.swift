//
//  FFyInTextBar.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit


class FFyInTextBar: UIView {

    var backBtnClickBlock: (()->Void)?
    var textInputBtnClickBlock: (()->Void)?
    var textFontSelectBlock: ((String, IndexPath)->Void)?
    var textColorSelectBlock: ((String, IndexPath)->Void)?
    let textInputBtn = UIButton()
    var collection: UICollectionView!
    var textInputCloseImgVClickBlock: (()->Void)?
    
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
        
        textInputBtn.backgroundColor(.white)
            .titleColor(UIColor.black)
            .font(18, "Montserrat-Light")
            .adhere(toSuperview: self)
            .title("Input text")
        textInputBtn.contentHorizontalAlignment = .left
        textInputBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        textInputBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(8)
            $0.height.equalTo(54)
            $0.width.equalTo(340)
        }
        textInputBtn.layer.cornerRadius = 54/2
        textInputBtn.addTarget(self, action: #selector(textInputClick(sender: )), for: .touchUpInside)
        
        //
        let textInputCloseImgV = UIButton()
        textInputCloseImgV.image(UIImage(named: "cancel_img"))
            .adhere(toSuperview: textInputBtn)
        textInputCloseImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
        textInputCloseImgV.addTarget(self, action: #selector(textInputCloseImgVClick(sender: )), for: .touchUpInside)
        
        //
        let fontBar = FFyInTexstFontView()
        fontBar.adhere(toSuperview: self)
        fontBar.fontDidSelectBlock = {
            [weak self] fontN, indexP in
            guard let `self` = self else {return}
            self.textFontSelectBlock?(fontN, indexP)
        }
        fontBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(textInputBtn.snp.bottom).offset(10)
            $0.height.equalTo(45)
        }
        
        //
        let colorBar = FFyInTexstColorView()
        colorBar.adhere(toSuperview: self)
        colorBar.colorDidSelectBlock = {
            [weak self] fontN, indexP in
            guard let `self` = self else {return}
            self.textColorSelectBlock?(fontN, indexP)
        }
        colorBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(fontBar.snp.bottom).offset(8)
            $0.height.equalTo(45)
        }
        
        
    }
    
    @objc func textInputCloseImgVClick(sender: UIButton) {
        
        textInputCloseImgVClickBlock?()
    }

}

extension FFyInTextBar {
     
}

extension FFyInTextBar {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
 
    @objc func textInputClick(sender: UISlider) {
        textInputBtnClickBlock?()
    }
    
    
    
    
}

