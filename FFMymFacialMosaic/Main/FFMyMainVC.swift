//
//  FFMyMainVC.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

import UIKit
import SnapKit
import Photos
import YPImagePicker

class FFMyMainVC: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        AFlyerLibManage.event_LaunchApp()
        
        setupView()
        
    }
    

    func setupView() {
        view.backgroundColor(UIColor(hexString: "E8EDF2")!)
        //
        let bgImgV = UIImageView()
        bgImgV.adhere(toSuperview: view)
            .image("home_bg_img")
            .contentMode(.scaleAspectFill)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            bgImgV.roundCorners([.bottomLeft, .bottomRight], radius: 30)
        }
        
        //
        let bottomV = UIView()
        bottomV.backgroundColor(UIColor.white)
            .adhere(toSuperview: view)
        bottomV.layer.cornerRadius = 24
        bottomV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(322)
            $0.height.equalTo(224)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-53)
        }
        //
        let cameraBtn = UIButton()
        cameraBtn
            .backgroundColor(.clear)
            .backgroundImage(UIImage(named: "camera_img"))
            .adhere(toSuperview: bottomV)
        cameraBtn.snp.makeConstraints {
            $0.top.equalTo(15)
            $0.left.equalTo(20)
            $0.width.equalTo(133)
            $0.height.equalTo(116)
        }
        cameraBtn.addTarget(self, action: #selector(cameraBtnClick(sender: )), for: .touchUpInside)
        let cameraNameL = UILabel()
        cameraNameL.fontName(16, "Montserrat-Bold")
            .color(.white)
            .numberOfLines(2)
            .text("Take\nPhoto")
            .adhere(toSuperview: cameraBtn)
        cameraNameL.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalTo(20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        let albumBtn = UIButton()
        albumBtn.backgroundImage(UIImage(named: "album_img"))
            .backgroundColor(.clear)
            .adhere(toSuperview: bottomV)
        albumBtn.snp.makeConstraints {
            $0.top.equalTo(15)
            $0.right.equalTo(-20)
            $0.width.equalTo(133)
            $0.height.equalTo(116)
        }
        albumBtn.addTarget(self, action: #selector(albumBtnClick(sender: )), for: .touchUpInside)
        let albumNameL = UILabel()
        albumNameL.fontName(16, "Montserrat-Bold")
            .color(.white)
            .text("Photo\nAlbum")
            .numberOfLines(2)
            .adhere(toSuperview: albumBtn)
        albumNameL.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.equalTo(20)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
 
        let settingBtn = UIButton()
        settingBtn.backgroundImage(UIImage(named: "app_setting_img"))
            .backgroundColor(.clear)
            .adhere(toSuperview: bottomV)
        settingBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-24)
            $0.right.equalTo(-20)
            $0.left.equalTo(20)
            $0.height.equalTo(56)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        let settingNameL = UILabel()
        settingNameL.fontName(16, "Montserrat-Bold")
            .color(.white)
            .text("Setting")
            .adhere(toSuperview: settingBtn)
        settingNameL.snp.makeConstraints {
            $0.left.equalTo(26)
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        //
        let iconImgV = UIImageView()
        iconImgV.image("fsuxmain")
            .adhere(toSuperview: view)
            .contentMode(.scaleAspectFit)
        iconImgV.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.bottom.equalTo(bottomV.snp.top).offset(-150)
            $0.width.height.equalTo(56)
        }
        
        //
        let titLabel = UILabel()
        titLabel.adhere(toSuperview: view)
            .text("Art\nMosaic")
            .color(.white)
            .numberOfLines(2)
            .fontName(24, "Montserrat-Bold")
        titLabel.snp.makeConstraints {
            $0.left.equalTo(iconImgV.snp.left)
            $0.top.equalTo(iconImgV.snp.bottom).offset(5)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
    }
    
    
    

}

extension FFMyMainVC {
    @objc func cameraBtnClick(sender: UIButton) {
        let vc = FFyInCameraVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func albumBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    @objc func settingBtnClick(sender: UIButton) {
        let settingVC = FFyInSettingVC()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
}

extension FFMyMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {

                            self.presentLimitedPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {

                                self.presentLimitedPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
                
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor(UIColor.white)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
     
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            
            
            let vc = FFyInEditVC(origImg: image)
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    
    
}
