//
//  FFyInSettingVC.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//
import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit

 
class FFyInSettingVC: UIViewController {
    var upVC: UIViewController?
    let backBtn = UIButton(type: .custom)
    let titleLabel = UILabel(text: "Setting")
    let privacyBtn = HPymSettingBtn()
    let termsBtn = HPymSettingBtn()
    let feedbackBtn = HPymSettingBtn()
    let coinLabel = UILabel()
    
//    let loginBtn = HPymSettingLoginBtn()
//    let logoutBtn = HPymSettingLoginBtn()
    
    
    var loginBtnClickBlock: (()->Void)?
    
    
    let accountBgView = UIView()
    let coinInfoBgView = UIView()
    let userNameLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        setupView()
        setupContent()
//        updateUserAccountStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coinLabel.text("Your coins: \(InCymCoinManagr.default.coinCount)")
    }
     
}

extension FFyInSettingVC {
    func setupView() {
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "back_img"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        
//        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 18)
//        titleLabel.textAlignment = .center
//        view.addSubview(titleLabel)
//        titleLabel.textColor = UIColor(hexString: "#121212")
//        titleLabel.snp.makeConstraints {
//            $0.centerY.equalTo(backBtn)
//            $0.centerX.equalToSuperview()
//            $0.height.equalTo(28)
//            $0.width.equalTo(100)
//        }
        
    }
    
    func setupContent() {
        
        // login

//        loginBtn.nameLa.text("Login account")
//        loginBtn.btn.setTitle("Log in", for: .normal)
//        view.addSubview(loginBtn)
//        loginBtn.snp.makeConstraints {
//            $0.width.equalTo(748/2 - 20)
//            $0.height.equalTo(176/2)
//            $0.right.equalToSuperview()
//            $0.top.equalTo(backBtn.snp.bottom).offset(26)
//        }
//        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        
        
        
        //
        let storeBgBtn = UIButton()
        storeBgBtn.backgroundImage(UIImage(named: "store_coine_banner"))
            .adhere(toSuperview: view)
        storeBgBtn.snp.makeConstraints {
            $0.left.equalTo(18)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(22)
            $0.height.equalTo(158)
        }
        storeBgBtn.addTarget(self, action: #selector(stoerBtnClick(sender: )), for: .touchUpInside)
        let nLabel = UILabel()
        nLabel.fontName(24, "Montserrat-Bold")
            .color(UIColor.white)
            .text("Store Coins")
            .adhere(toSuperview: storeBgBtn)
        nLabel.snp.makeConstraints {
            $0.left.equalTo(22)
            $0.bottom.equalTo(storeBgBtn.snp.centerY).offset(-10)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        coinLabel.fontName(18, "Montserrat-Bold")
            .color(UIColor.white)
            .text("Your coins: \(InCymCoinManagr.default.coinCount)")
            .adhere(toSuperview: storeBgBtn)
        coinLabel.snp.makeConstraints {
            $0.left.equalTo(22)
            $0.top.equalTo(storeBgBtn.snp.centerY).offset(10)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        // feed
        feedbackBtn.nameLa.text("Feedback")
        view.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(18)
            $0.height.equalTo(55)
            $0.top.equalTo(storeBgBtn.snp.bottom).offset(34)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        
        
        
        
        // privacy
        privacyBtn.nameLa.text("Privacy Policy")
        view.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(18)
            $0.height.equalTo(55)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(20)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        
        // terms
        
        termsBtn.nameLa.text("Terms of use")
        view.addSubview(termsBtn)
        termsBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(18)
            $0.height.equalTo(55)
            $0.top.equalTo(privacyBtn.snp.bottom).offset(20)
            
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        
        
        
        // logout
//        logoutBtn.nameLa.text("")
//        logoutBtn.btn.setTitle("Log out", for: .normal)
//        view.addSubview(logoutBtn)
//        logoutBtn.snp.makeConstraints {
//            $0.width.equalTo(748/2 - 20)
//            $0.height.equalTo(176/2)
//            $0.right.equalToSuperview()
//            $0.top.equalTo(backBtn.snp.bottom).offset(26)
//        }
//        logoutBtn.addTarget(self, action: #selector(logoutBtnClick(sender:)), for: .touchUpInside)
        
        
        
        // user name label
//        view.addSubview(userNameLabel)
//        userNameLabel.textAlignment = .center
//        userNameLabel.adjustsFontSizeToFitWidth = true
//        userNameLabel.textColor = .black
//        userNameLabel.font = UIFont(name: "Avenir-BoldMT", size: 18)
//        userNameLabel.snp.makeConstraints {
//            $0.center.equalTo(titleLabel)
//            $0.height.equalTo(40)
//            $0.left.equalTo(backBtn.snp.right).offset(10)
//        }
//
//
//        // accountBgView
//        accountBgView.backgroundColor = .clear
//        view.addSubview(accountBgView)
//        accountBgView.snp.makeConstraints {
//            $0.center.equalTo(loginBtn)
//            $0.width.equalToSuperview()
//            $0.centerX.equalToSuperview()
//
//        }
//
//        // coin info bg view
//        let topCoinLabel = UILabel()
//        topCoinLabel.textAlignment = .right
//        topCoinLabel.text = "\(InCymCoinManagr.default.coinCount)"
//        topCoinLabel.textColor = UIColor(hexString: "#2A2A2A")
//        topCoinLabel.font = UIFont(name: "PingFangSC-Semibold", size: 22)
//        accountBgView.addSubview(topCoinLabel)
//        topCoinLabel.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.centerX.equalToSuperview().offset(-28)
//            $0.height.equalTo(30)
//            $0.width.greaterThanOrEqualTo(25)
//        }
//
//        let coinImageV = UIImageView()
//        coinImageV.image = UIImage(named: "coins_icon3")
//        coinImageV.contentMode = .scaleAspectFit
//        accountBgView.addSubview(coinImageV)
//        coinImageV.snp.makeConstraints {
//            $0.centerY.equalTo(topCoinLabel)
//            $0.left.equalTo(topCoinLabel.snp.right).offset(10)
//            $0.width.height.equalTo(20)
//        }
        
    }
}

extension FFyInSettingVC {
//    func updateUserAccountStatus() {
//        if let userModel = LoginManage.currentLoginUser() {
//            let userName  = userModel.userName
//            let name = (userName?.count ?? 0) > 0 ? userName : "Signed in with apple ID"
////            accountBgView.isHidden = false
//            logoutBtn.nameLa.text(name)
//            logoutBtn.isHidden = false
//            loginBtn.isHidden = true
//            userNameLabel.isHidden = false
//            titleLabel.isHidden = true
//        } else {
//            logoutBtn.nameLa.text("")
////            accountBgView.isHidden = true
//            logoutBtn.isHidden = true
//            loginBtn.isHidden = false
//            userNameLabel.isHidden = true
//            titleLabel.isHidden = false
//        }
//    }
}

extension FFyInSettingVC {
    @objc func stoerBtnClick(sender: UIButton) {
        let storeVC = FFyInStoreVC()
        self.navigationController?.pushViewController(storeVC, animated: true)
    }
}



extension FFyInSettingVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
}



extension FFyInSettingVC {
    @objc func privacyBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
//    @objc func loginBtnClick(sender: UIButton) {
//        backBtnClick(sender: backBtn)
//        if let mainVC = self.upVC as? HPymMainVC {
//            mainVC.showLoginVC()
//        }
//        
//    }
//    
//    @objc func logoutBtnClick(sender: UIButton) {
//        LoginManage.shared.logout()
//        updateUserAccountStatus()
//    }
    
    
     
}



extension FFyInSettingVC: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"
            
            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
            controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


class HPymSettingLoginBtn: UIButton {
    
    var nameLa = UILabel()
    let btn = UIButton()
    var btnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let bgImgV = UIImageView()
        bgImgV
            .image("coin_bg_pic")
            .adhere(toSuperview: self)
            .contentMode(.scaleAspectFit)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        nameLa
            .fontName(18, "Didot")
            .color(.black)
            .text("Login")
            .numberOfLines(2)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        nameLa.snp.makeConstraints {
            $0.left.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-150)
            $0.height.greaterThanOrEqualTo(60)
        }
        
        //
        btn.isUserInteractionEnabled(false)
        btn
            .backgroundColor(UIColor(hexString: "#2FDF84")!)
            .titleColor(UIColor.white)
            .font(18, "Didot-Bold")
            .adhere(toSuperview: self)
        btn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
            $0.width.equalTo(85)
            $0.height.equalTo(40)
        }
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
//        btn.addTarget(self, action: #selector(btnClick(sender: )), for: .touchUpInside)
        
        
    }
    
//    @objc func btnClick(sender: UIButton) {
//        btnClickBlock?()
//    }
    
    
}


class HPymSettingBtn: UIButton {
    
    var nameLa = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        let bgImgV = UIImageView()
        bgImgV
//            .image("coin_bg_pic")
            .backgroundColor(UIColor(hexString: "47D2FF")!)
            .adhere(toSuperview: self)
            .contentMode(.scaleAspectFit)
        bgImgV.layer.cornerRadius = 55/2
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        nameLa
            .fontName(15, "Montserrat-Bold")
            .color(.white)
            .text("")
            .numberOfLines(2)
            .textAlignment(.left)
            .adhere(toSuperview: self)
        nameLa.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(55)
        }
    }
    
    
}

