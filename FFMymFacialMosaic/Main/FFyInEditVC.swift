//
//  FFyInEditVC.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit
import DeviceKit
import BBMetalImage
import Photos

class FFyInEditVC: UIViewController {

    var origImg: UIImage
    let bottomBar = UIView()
    let backBtn = UIButton()
    let contentBgV = UIView()
    let contentImgV = UIImageView()
    let mosaicImgV = UIImageView()
    let overlayerImgV = UIImageView()
    var viewDidAppearOnce = Once()
    
    var paintContentView : MaskView!
    var currentMaskShapeItem: InCymStickerItem?
    let brushBtn = FFyInMainBottomBtn(frame: .zero, iconName: "brush_img", titleNameStr: "Brush")
    let maskBtn = FFyInMainBottomBtn(frame: .zero, iconName: "shape_img", titleNameStr: "Mask")
    let textBtn = FFyInMainBottomBtn(frame: .zero, iconName: "text_ime", titleNameStr: "Text")
    let filterBtn = FFyInMainBottomBtn(frame: .zero, iconName: "fliter_img", titleNameStr: "Filter")
       
    let mascBar = FFyInMasacBrushView()
    let maskShapeBar = FFyInMaskSelectBar()
    let filterBar = FFyInFilterBar()
    let textBar = FFyInTextBar()
    
    var isAddNewText: Bool = false
    
    var currentSelectFilterItem: GCFilterItem?
    let coinAlertView = FFyInCoinAlertView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupToolBar()
        setupCoinAlertView()
        setupActionBlock()
    }
    
    init(origImg: UIImage) {
        self.origImg = origImg
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidAppearOnce.run {
            var topOffset: CGFloat = 0
            var leftOffset: CGFloat = 0
            if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
    //            leftOffset = 30
    //            topOffset = 50
            }
            
            
            
            let width: CGFloat = UIScreen.main.bounds.width - (leftOffset * 2)
            let height: CGFloat = width
            
            topOffset = ((bottomBar.frame.midY - backBtn.frame.maxY) - height) / 2
            contentBgV.adhere(toSuperview: view)
            contentBgV.frame = CGRect(x: leftOffset, y: topOffset, width: width, height: height)
             
            //
            contentImgV
                .image(origImg)
                .contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            contentImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(contentBgV)
            }
            
            //
            let mosaicImg = BBMetalPixellateFilter(fractionalWidth: 0.02).filteredImage(with: origImg)
            mosaicImgV
                .image(mosaicImg)
                .contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            mosaicImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(contentBgV)
            }
            
            MaskConfigManager.sharedInstance().lineColorOne = UIColor.white
            MaskConfigManager.sharedInstance().strokeType = .normal
            changePaintLineWidth(lineWidth: 20)
            //
            paintContentView = MaskView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.width, height: UIScreen.width))
            mosaicImgV.addSubview(paintContentView)
            mosaicImgV.mask = paintContentView
            paintContentView.perPaintMoveCompletion = {[weak self] canBeforeAction, canNextAction in
                guard let `self` = self else { return }
                
            }
            showPaintContentView(isInteractionEnabled: false)
            //
            overlayerImgV.contentMode(.scaleAspectFit)
                .adhere(toSuperview: contentBgV)
            overlayerImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(contentBgV)
            }
            
            //
            
            self.view.bringSubviewToFront(self.mascBar)
            self.view.bringSubviewToFront(self.maskShapeBar)
            self.view.bringSubviewToFront(self.textBar)
            self.view.bringSubviewToFront(self.filterBar)
            
        }
        
    }
    
}

extension FFyInEditVC {
    
    func setupCoinAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showUnlockcoinAlertView() {
        // show coin alert
        
        self.view.bringSubviewToFront(self.coinAlertView)
        
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if InCymCoinManagr.default.coinCount >= InCymCoinManagr.default.coinCostCount {
                DispatchQueue.main.async {
                     
                    InCymCoinManagr.default.costCoin(coin: InCymCoinManagr.default.coinCostCount)
                    DispatchQueue.main.async {
                        self.saveAction()
                        
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient Coins, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(FFyInStoreVC(), animated: true)
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
    }
    
}

extension FFyInEditVC {
    func clearPaintPath() {
        self.paintContentView.clearPath()
    }
    
    func showPaintContentView(isInteractionEnabled:Bool)  {
        paintContentView.isUserInteractionEnabled = isInteractionEnabled
        paintContentView.touchView.canEditStatus = isInteractionEnabled
        
        if isInteractionEnabled {
            for stickerAddon in InCymAddonManager.default.addonTextsList {
                stickerAddon.isUserInteractionEnabled = false
            }
        } else {
            for stickerAddon in InCymAddonManager.default.addonTextsList {
                stickerAddon.isUserInteractionEnabled = true
            }
        }
    }
    
    func changePaintLineWidth(lineWidth: Float) {
        MaskConfigManager.sharedInstance().lineWidth = CGFloat(lineWidth)
    }
    
    
}

extension FFyInEditVC {
    func setupView() {
        view.backgroundColor(.white)
        //
        
        backBtn
            .backgroundColor(UIColor.clear)
            .image(UIImage(named: "back_img"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let saveBtn = UIButton()
        saveBtn
            .backgroundColor(UIColor.clear)
            .image(UIImage(named: "img_done_ic"))
            .adhere(toSuperview: view)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(44)
        }
        
        //
        bottomBar
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(190)
            
        }
        
        //
        
        //
        
        brushBtn.adhere(toSuperview: bottomBar)
        maskBtn.adhere(toSuperview: bottomBar)
        textBtn.adhere(toSuperview: bottomBar)
        filterBtn.adhere(toSuperview: bottomBar)
        
        let width: CGFloat = 70
        let height: CGFloat = 85
        let padding: CGFloat = (UIScreen.width - width * 4 - 1) / 5
        brushBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(padding)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            
        }
        maskBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(brushBtn.snp.right).offset(padding)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            
        }
        textBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(maskBtn.snp.right).offset(padding)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            
        }
        filterBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(textBtn.snp.right).offset(padding)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            
        }
        
        //
        brushBtn.addTarget(self, action: #selector(brushBtnClick(sender: )), for: .touchUpInside)
        maskBtn.addTarget(self, action: #selector(maskBtnClick(sender: )), for: .touchUpInside)
        textBtn.addTarget(self, action: #selector(textBtnClick(sender: )), for: .touchUpInside)
        filterBtn.addTarget(self, action: #selector(filterBtnClick(sender: )), for: .touchUpInside)
        
        
    }
    
    func setupToolBar() {
        var barHeight: CGFloat = 290
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 6.9 {
            barHeight = 230
        }
        
        mascBar.adhere(toSuperview: self.view)
        mascBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(barHeight)
        }
        mascBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.mascBar.isHidden = true
                self.showPaintContentView(isInteractionEnabled: false)
            }
        }
        mascBar.clearBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.clearPaintPath()
            }
        }
        mascBar.sliderChangeClickBlock = {
            [weak self] lineWidth in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.changePaintLineWidth(lineWidth: lineWidth)
            }
        }
        
        //
        
        maskShapeBar.adhere(toSuperview: view)
        maskShapeBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(barHeight)
        }
        maskShapeBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.maskShapeBar.isHidden = true
            }
        }
     
        maskShapeBar.selectMaskOverlayerItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.udpateMaskOverlayer(item: item)
            }
        }
        
        //
        
        
        filterBar.originalImage = origImg.scaled(toWidth: 150)
        filterBar.adhere(toSuperview: view)
        filterBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(barHeight)
        }
        filterBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.filterBar.isHidden = true
            }
        }
        
        filterBar.didSelectFilterItemBlock = {
            [weak self] filterItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.changeFilter(item: filterItem)
            }
        }
        
        //
        
        textBar.adhere(toSuperview: view)
        textBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(barHeight)
        }
        textBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.textBar.isHidden = true
                InCymAddonManager.default.cancelCurrentAddonHilightStatus()
            }
        }
        textBar.textInputBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.textBar.isHidden = true
                
                self.isAddNewText = true
                
                self.showTextInputViewStatus(contentString: self.textBar.textInputBtn.titleLabel?.text ?? "", font: UIFont(name: "AvenirNext-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18))
            }
            
        }
        
        textBar.textInputCloseImgVClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.textBar.isHidden = true
                
                self.isAddNewText = true
                self.textBar.textInputBtn.text("")
                self.showTextInputViewStatus(contentString: "", font: UIFont(name: "AvenirNext-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18))
            }
        }
        
        textBar.textFontSelectBlock = {
            [weak self] fontN, indexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                InCymAddonManager.default.replaceSetupTextAddonFontItem(fontItem: fontN, fontIndexPath: indexP, canvasView: self.contentBgV)
            }
        }
        
        
        textBar.textColorSelectBlock = {
            [weak self] colorN, indexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                let colorc = UIColor(hexString: colorN) ?? UIColor.white
                InCymAddonManager.default.replaceSetupTextAddonTextColor(color: colorc, canvasView: self.contentBgV)
            }
        }
        
        //
        mascBar.isHidden = true
        maskShapeBar.isHidden = true
        textBar.isHidden = true
        filterBar.isHidden = true
        
    }
    
    func udpateMaskOverlayer(item: InCymStickerItem?) {
        if let name = item?.bigName {
            overlayerImgV.image(name)
        } else {
            overlayerImgV.image = nil
        }
        currentMaskShapeItem = item
        
    }
    
    func changeFilter(item: GCFilterItem?) {
        currentSelectFilterItem = item
        
        if let filterItem = item {
            if let filteredImg = InCymDataManager.default.filterOriginalImage(image: self.origImg, lookupImgNameStr: filterItem.imageName) {
                self.contentImgV.image = filteredImg
                let mosaicImg = BBMetalPixellateFilter(fractionalWidth: 0.02).filteredImage(with: filteredImg)
                mosaicImgV
                    .image(mosaicImg)
                
            }
        } else {
            self.contentImgV.image = origImg
            let mosaicImg = BBMetalPixellateFilter(fractionalWidth: 0.02).filteredImage(with: origImg)
            mosaicImgV
                .image(mosaicImg)
        }
        
        
    }
    
    func saveAction() {
        if let imgs = self.contentBgV.screenshot {
            self.saveImgsToAlbum(imgs: [imgs])
        }
        
    }
    
    
}

extension FFyInEditVC {
    func saveImgsToAlbum(imgs: [UIImage]) {
        HUD.hide()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {
                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
            albumPermissionsAlet()
        }
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        
        
        DispatchQueue.main.async {
            let title = ""
            let message = "Photo saved successfully!"
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .cancel, handler: { (alert) in
                 DispatchQueue.main.async {
                 }
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func albumPermissionsAlet() {
        let alert = UIAlertController(title: "Ooops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSystemAppSetting() {
        let url = NSURL.init(string: UIApplication.openSettingsURLString)
        let canOpen = UIApplication.shared.canOpenURL(url! as URL)
        if canOpen {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
 
}
extension FFyInEditVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        if self.currentMaskShapeItem?.isPro == true {
            showUnlockcoinAlertView()
        } else {
            saveAction()
        }
    }
    
    @objc func brushBtnClick(sender: UIButton) {
        mascBar.isHidden = false
        showPaintContentView(isInteractionEnabled: true)
        InCymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    @objc func maskBtnClick(sender: UIButton) {
        maskShapeBar.isHidden = false
        InCymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    @objc func textBtnClick(sender: UIButton) {
        textBar.isHidden = false
        InCymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    @objc func filterBtnClick(sender: UIButton) {
        filterBar.isHidden = false
        InCymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
    
    
    
    
    
    
}


extension FFyInEditVC {
    func showTextInputViewStatus(contentString: String, font: UIFont) {
        let textinputVC = FFyInTextInputVC()
        self.addChild(textinputVC)
        view.addSubview(textinputVC.view)
        textinputVC.view.alpha = 0
        textinputVC.startEdit()
        if contentString == "" {
//            textinputVC.contentTextView.placeholder = "Halloween"
        } else {
            textinputVC.contentText = contentString
//            textinputVC.contentTextView.text = contentString
        }
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            textinputVC.view.alpha = 1
        }
        textinputVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        textinputVC.contentTextView.becomeFirstResponder()
        textinputVC.cancelClickActionBlock = {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }
            
            textinputVC.contentTextView.resignFirstResponder()
        }
        textinputVC.doneClickActionBlock = {
            [weak self] contentString, isAddNew in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }
            textinputVC.contentTextView.resignFirstResponder()
            InCymAddonManager.default.replaceSetupTextContentString(contentString: contentString, canvasView: self.contentBgV, isAddNewTextAddon: self.isAddNewText)
            self.textBar.textInputBtn.text(contentString)
            
        }
    }
    
    func addNewfirstTextView() {
        
//        WCymAddonManager.default.replaceSetupTextAddonFontItem(fontItem: "AvenirNext-Medium", fontIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasBgV)
        
        InCymAddonManager.default.replaceSetupTextBgColor(bgColorName: "#00000000", indexPath: IndexPath(item: 0, section: 0), canvasView: self.contentBgV)
    }

    func setupActionBlock() {
          
        InCymAddonManager.default.removeStickerAddonActionBlock = { [weak self] in
            guard let `self` = self else {return}
            
            
        }
        
        InCymAddonManager.default.doubleTapTextAddonActionBlock = { [weak self] contentString, font, colorStr in
            guard let `self` = self else {return}
            
            let fontT = UIFont(name: font, size: 28 ) ?? UIFont.systemFont(ofSize: 28)
            self.isAddNewText = false
            self.showTextInputViewStatus(contentString: contentString, font: fontT)
            
        }
        
        
    }
    
}



class FFyInMainBottomBtn: UIButton {
    
    var iconImgV = UIImageView()
    
    var nameLa = UILabel()
    
    var iconName: String
    var titleNameStr: String
    
    
    init(frame: CGRect, iconName: String, titleNameStr: String) {
        self.iconName = iconName
        self.titleNameStr = titleNameStr
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
         
        iconImgV
            .image(iconName)
            .adhere(toSuperview: self)
            .contentMode(.scaleAspectFit)
        
        iconImgV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        //
        nameLa
            .fontName(12, "Montserrat-Light")
            .color(UIColor(hexString: "#47D2FF")!)
            .text(titleNameStr)
            .numberOfLines(1)
            .textAlignment(.center)
            .adhere(toSuperview: self)
        nameLa.snp.makeConstraints {
            $0.top.equalTo(iconImgV.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(25)
        }
    }
    
    
}

