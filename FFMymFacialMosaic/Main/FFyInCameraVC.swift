//
//  FFyInCameraVC.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit
import BBMetalImage
import AVFoundation
import SnapKit
import DeviceKit


class FFyInCameraVC: UIViewController {

    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
    let overlayerImgV = UIImageView()
    let backBtn = UIButton()
    let bottomBar = UIView()
    
    var takePhotoBtn = UIButton(type: .custom)
    var camPositionBtn = UIButton(type: .custom)
    
    var currentOverlayerItem: InCymStickerItem?
    var currentoverlayerIndex: Int = 0
    
    var viewDidAppearOnce = Once()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
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
            
            
            metalView = BBMetalView(frame: CGRect(x: leftOffset, y: topOffset, width: width, height: height))
            metalView.adhere(toSuperview: view)
            metalView.backgroundColor(.purple)
            //
            camera = BBMetalCamera(sessionPreset: .hd1920x1080)
            camera.add(consumer: metalView)
            
            //
            
            overlayerImgV.contentMode(.scaleAspectFit)
                .adhere(toSuperview: view)
            overlayerImgV.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(metalView)
            }
            camera.start()
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
        
        camera.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
        
    }

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
        
        bottomBar
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(190)
        }
        
        //
        takePhotoBtn
            .image("camera_ok_img")
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: bottomBar)
        takePhotoBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(72)
        }
        takePhotoBtn.addTarget(self, action: #selector(takePhotoBtnClick(sender: )), for: .touchUpInside)
        //
        
        //
        camPositionBtn
            .backgroundColor(UIColor.clear)
            .image(UIImage(named: "camera_rota_ic"))
            .adhere(toSuperview: bottomBar)
        camPositionBtn.addTarget(self, action: #selector(camPositionBtnClick(sender: )), for: .touchUpInside)
        camPositionBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.left.equalToSuperview().offset(25)
            $0.width.height.equalTo(50)
        }
        
        //
        let changeBtn = UIButton()
        changeBtn
            .backgroundColor(UIColor.clear)
            .image(UIImage(named: "suiji_choose_img"))
            .adhere(toSuperview: bottomBar)
        changeBtn.addTarget(self, action: #selector(chagneOverlayerBtnClick(sender: )), for: .touchUpInside)
        changeBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar.snp.centerY)
            $0.right.equalToSuperview().offset(-25)
            $0.width.height.equalTo(50)
        }
        
        //
        let cameraBgV = UIView()
        cameraBgV.adhere(toSuperview: view)
        cameraBgV.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        //
        //
        
        
        
        
    }
     
    
    
}

extension FFyInCameraVC {
    func takePhotoProcess(image: UIImage) {
        //
        var finalImg: UIImage = image
        
        if camera.position == .front {
            // flip
            let mirrorFilter = BBMetalFlipFilter(horizontal: true, vertical: false)
            if let img = mirrorFilter.filteredImage(with: finalImg) {
                finalImg = img
            }
        }
        
        // crop
        let topOffsety: Float = ((1920 - 1080) / 2) / 1920
        let heightP: Float = 1080 / 1920
        let cropFilter = BBMetalCropFilter(rect: BBMetalRect(x: 0, y: topOffsety, width: 1, height: heightP))
        
        if let img = cropFilter.filteredImage(with: finalImg) {
            //
            let saveV = UIView()
            saveV.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            let saveImgV = UIImageView()
            saveImgV.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            saveImgV.image = img
            saveImgV.adhere(toSuperview: saveV)
            //
            if let overlayerName = currentOverlayerItem?.bigName {
                let overlayerImgV = UIImageView()
                overlayerImgV.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                overlayerImgV.image = UIImage(named: overlayerName)
                overlayerImgV.adhere(toSuperview: saveV)
            }
            
            if let saveImg = saveV.screenshot {
                self.showEditVC(img: saveImg)
            }
            
        }
    }
    
    func showEditVC(img: UIImage) {
        let vc = FFyInEditVC(origImg: img)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FFyInCameraVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func takePhotoBtnClick(sender: UIButton) {
        
        camera.capturePhoto { [weak self] info in
            switch info.result {
            case let .success(texture):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if let img = texture.bb_image {
                        self.takePhotoProcess(image: img)
                    }
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func chagneOverlayerBtnClick(sender: UIButton) {
        var nCurrent = currentoverlayerIndex + 1
        if nCurrent >= InCymDataManager.default.overlayerList.count {
            nCurrent = 0
        }
        
        let item = InCymDataManager.default.overlayerList[nCurrent]
        currentoverlayerIndex = nCurrent
        currentOverlayerItem = item
        
        self.overlayerImgV.image = UIImage(named: item.thumbName ?? "")
        
    }
    
    @objc func camPositionBtnClick(sender: UIButton) {
        camera.switchCameraPosition()
    }
}
