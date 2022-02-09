//
//  FFyInCoinAlertView.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit


import UIKit

class FFyInCoinAlertView: UIView {
    
    var backBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.84)
//        //
//        var blurEffect = UIBlurEffect(style: .light)
//        var blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.frame
//        addSubview(blurEffectView)
//        blurEffectView.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
//
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let contentV = UIView()
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: self)
        contentV.layer.cornerRadius = 16
        contentV.layer.masksToBounds = true
//        contentV.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
//        contentV.layer.shadowOffset = CGSize(width: 0, height: 0)
//        contentV.layer.shadowRadius = 3
//        contentV.layer.shadowOpacity = 0.8
//        contentV.layer.borderWidth = 2
//        contentV.layer.borderColor = UIColor.black.cgColor
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.width - 16 * 2)
            $0.height.equalTo(332)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-0)
        }
        
        //
         
        let coinImgV = UIImageView()
            .image("popup_coins_store")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentV)
        coinImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentV.snp.top).offset(0)
            $0.width.equalTo(64)
            $0.height.equalTo(56)
        }
        
        //
        let titLab = UILabel()
        
            .text("\(InCymCoinManagr.default.coinCostCount) coins are required to use this item.")
            .textAlignment(.center)
            .numberOfLines(0)
            .fontName(18, "Montserrat-Bold")
            .color(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: contentV)
        
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(coinImgV.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(50)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
//        let contentBgImgV = UIImageView()
//        contentBgImgV.image("popup_pro")
//            .adhere(toSuperview: contentV)
//        contentBgImgV.snp.makeConstraints {
//            $0.left.right.top.bottom.equalToSuperview()
//        }
        
//        //
//
//        let titLab2 = UILabel()
//            .text("Using paid item will cost \(LPymCoinManagr.default.coinCostCount) coins.")
//            .textAlignment(.center)
//            .numberOfLines(0)
//            .fontName(16, "AvenirNext-Regular")
//            .color(UIColor(hexString: "#454D3D")!.withAlphaComponent(0.6))
//            .adhere(toSuperview: contentV)
//
//        titLab2.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(titLab.snp.bottom).offset(10)
//            $0.left.equalToSuperview().offset(50)
//            $0.height.greaterThanOrEqualTo(1)
//        }
        
        //AvenirNext-DemiBold
        
        ///
        //
        let okBtn = UIButton()
        okBtn
            .backgroundColor(UIColor(hexString: "#47D2FF")!)
            .titleColor(UIColor.white)
            .title("OK")
            .font(16, "Montserrat-Bold")
            .adhere(toSuperview: contentV)
        okBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titLab.snp.bottom).offset(26)
            $0.width.equalTo(240)
            $0.height.equalTo(55)
        }
        okBtn.layer.cornerRadius = 55/2
        okBtn.addTarget(self, action: #selector(okBtnClick(sender: )), for: .touchUpInside)
        
        //
        let cancelBtn = UIButton()
        cancelBtn
            .backgroundColor(.clear)
            .titleColor(UIColor(hexString: "#7B7B7B")!)
            .title("Cancel")
            .font(14, "Montserrat-Medium")
            .adhere(toSuperview: contentV)
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(okBtn.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(162)
            $0.height.equalTo(40)
        }
        
        cancelBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
    }
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
  }
