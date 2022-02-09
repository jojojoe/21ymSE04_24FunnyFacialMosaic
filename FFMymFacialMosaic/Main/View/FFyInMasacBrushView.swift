//
//  FFyInMasacBrushView.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit

class FFyInMasacBrushView: UIView {

    var backBtnClickBlock: (()->Void)?
    var clearBtnClickBlock: (()->Void)?
    var sliderChangeClickBlock: ((Float)->Void)?
    
    
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
        
        let slider = UISlider()
        
        slider.setMinimumTrackImage(UIImage(named: "brush_size_line"), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "brush_size_line"), for: .normal)
        
        slider.maximumValue = 60
        slider.minimumValue = 5
        slider.value = 20
        
        slider.setThumbImage(UIImage(named: "sldierPOint"), for: .normal)
        slider.addTarget(self, action: #selector(sliderChangeClick(sender: )), for: .valueChanged)
        slider.adhere(toSuperview: self)
        slider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(330)
            $0.height.greaterThanOrEqualTo(34)
        }
        
        
    }
    
    
}

extension FFyInMasacBrushView {
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func clearBtnClick(sender: UIButton) {
        clearBtnClickBlock?()
    }
    
    @objc func sliderChangeClick(sender: UISlider) {
        sliderChangeClickBlock?(sender.value)
    }
    
    
    
    
}
