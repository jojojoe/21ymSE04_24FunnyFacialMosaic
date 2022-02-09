//
//  FFyInTextInputVC.swift
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/27.
//

import UIKit
import SnapKit
import ZKProgressHUD

let maxLableCount: Int = 100
class FFyInTextInputVC: UIViewController {

    var cancelBtn: UIButton = UIButton.init(type: .custom)
    var doneBtn: UIButton = UIButton.init(type: .custom)
    
    var contentTextView: UITextView = UITextView.init()
    var cancelClickActionBlock: (()->Void)?
    var doneClickActionBlock: ((String, Bool)->Void)?
    
    var limitLabel: UILabel = UILabel.init(text: "0/\(maxLableCount)")
    let contentBgV = UIView()
    
    
    // Public
    var contentText: String = "" {
        didSet {
            updateLimitTextLabel(contentText: contentText)
//            "Begin writing your story here"
            let defaultText = "Double tap to add text"
            if contentText == defaultText || contentText == "" {
                contentTextView.text = ""
//                contentTextView.placeholder = defaultText
            } else {
                contentTextView.text = contentText
                contentTextView.placeholder = ""
                
            }
            
        }
    }
    var isAddNew: Bool = false
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextView()
        setupTextViewNotification()
        registKeyboradNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        contentTextView.text = "Halloween"
//        if contentTextView.text == "" {
//            contentTextView.text = "Halloween"
//            contentText = "Halloween"
//        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//
//            self.contentTextView.placeholder = "Halloween"
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatUI()
    }
    
    func registKeyboradNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(keyboardHeight)
        contentBgV.snp.remakeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalTo(140)
            $0.bottom.equalTo(view.snp.bottom).offset(-keyboardHeight)
        }
        
   
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        print(keyboardHeight)
        
    }
    
    
    
}

extension FFyInTextInputVC {
    
    func updatUI() {
        
         
         
    }
    
    func setupView() {
        
        view.backgroundColor = UIColor.clear
        
        // blur
//        let blur = UIBlurEffect(style: .dark)
//        let effectView = UIVisualEffectView.init(effect: blur)
//        view.addSubview(effectView)
//        effectView.snp.makeConstraints {
//            $0.top.left.bottom.right.equalToSuperview()
//        }
        
        //
        let bgClosebtn = UIButton()
        bgClosebtn.adhere(toSuperview: view)
        bgClosebtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)
        
        
        contentBgV.backgroundColor(UIColor(hexString: "47D2FF")!)
            .adhere(toSuperview: view)
        contentBgV.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalTo(140)
            $0.bottom.equalToSuperview()
        }
        
        bgClosebtn.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(contentBgV.snp.top)
        }
        
        
        contentBgV.addSubview(cancelBtn)
        contentBgV.addSubview(doneBtn)
        
        
        cancelBtn.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(44)
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
        }
        
        doneBtn.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(44)
            $0.height.equalTo(44)
            $0.centerY.equalTo(cancelBtn)
            $0.right.equalToSuperview().offset(-10)
        }
         
        
        
        cancelBtn.setImage(UIImage(named: "close_ic"), for: .normal)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)
        doneBtn
            .image(UIImage(named: "edit_done_ic"))
        
        doneBtn.backgroundColor = UIColor.clear
        doneBtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)
    }
    
    @objc
    func cancelBtnClick(btn: UIButton) {
        finishEdit()
        cancelClickActionBlock?()
    }
    
    @objc
    func doneBtnClick(btn: UIButton) {
        finishEdit()
        cancelClickActionBlock?()
    }
    
    @objc func okAddBtnClick(sender: UIButton) {
        finishEdit()
        var str: String = contentTextView.text
        if str == "" {
            str = "Double tap to add text"
        }
        doneClickActionBlock?(str, isAddNew)
    }
    
    func setupTextView() {
        
        //
        let textInputBgV = UIView()
        textInputBgV.backgroundColor(.white)
            .adhere(toSuperview: contentBgV)
        textInputBgV.layer.cornerRadius = 56/2
        textInputBgV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cancelBtn.snp.bottom).offset(2)
            $0.height.equalTo(56)
        }
        
        
        //
        contentTextView.backgroundColor = .clear
        contentTextView.textColor = UIColor(hexString: "#000000")
        contentTextView.font = UIFont(name: "AvenirNext-Regular", size: 18)
        contentBgV.addSubview(contentTextView)
        contentTextView.delegate = self
        contentTextView.textAlignment = .left
        contentTextView.snp.makeConstraints {
            $0.left.equalTo(textInputBgV.snp.left).offset(30)
            $0.right.equalTo(textInputBgV.snp.right).offset(-50)
            $0.centerY.equalTo(textInputBgV.snp.centerY)
            $0.height.equalTo(56)
        }

        limitLabel.isHidden = true
        limitLabel.textAlignment = .right
        limitLabel.font =  UIFont(name: "AvenirNext-Medium", size: 10)
        limitLabel.textColor = UIColor.white
        view.addSubview(limitLabel)
        limitLabel.snp.makeConstraints {
            $0.right.equalTo(contentTextView)
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        //
        let okAddBtn = UIButton()
        okAddBtn.image(UIImage(named: "add_text_img"))
            .contentMode(.center)
            .adhere(toSuperview: contentBgV)
        okAddBtn.snp.makeConstraints {
            $0.centerY.equalTo(textInputBgV.snp.centerY)
            $0.right.equalTo(contentBgV.snp.right).offset(-25)
            $0.width.height.equalTo(40)
        }
        okAddBtn.addTarget(self, action: #selector(okAddBtnClick(sender: )), for: .touchUpInside)
        
    }
    
}

extension FFyInTextInputVC {
    func finishEdit() {
        contentTextView.resignFirstResponder()
    }
    
    func startEdit() {
        contentTextView.becomeFirstResponder()
    }

    func updateLimitTextLabel(contentText: String) {
        
        limitLabel.text = "\(contentText.count)/\(maxLableCount)"
        if contentText.count >= maxLableCount {
            limitLabel.textColor = UIColor.white
            showCountLimitAlert()
        } else {
            limitLabel.textColor = UIColor.white
        }
    }

}
 

extension FFyInTextInputVC: UITextViewDelegate {
    
    func showCountLimitAlert() {
        if !ZKProgressHUD.isShowing {
            ZKProgressHUD.showInfo("No more than \(maxLableCount) characters.", maskStyle: nil, onlyOnceFont: nil, autoDismissDelay: 2, completion: nil)
        }
        
    }
    
    func setupTextViewNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewNotifitionAction), name: UITextView.textDidChangeNotification, object: nil);
    }
    @objc
    func textViewNotifitionAction(userInfo:NSNotification){
        guard let textView = userInfo.object as? UITextView else { return }
        if textView.text.count >= maxLableCount {
            let selectRange = textView.markedTextRange
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    // 高亮部分不进行截取，否则中文输入会把高亮区域的拼音强制截取为字母，等高亮取消后再计算字符总数并截取
                    return
                }

            }
            textView.text = String(textView.text[..<String.Index(encodedOffset: maxLableCount)])

            // 对于粘贴文字的case，粘贴结束后若超出字数限制，则让光标移动到末尾处
            textView.selectedRange = NSRange(location: textView.text.count, length: 0)
        }
        
        contentText = textView.text
        
    }
     
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // range: The range of characters to be replaced.(location、count)
        // 高亮控制
        let selectedRange = textView.markedTextRange
        if let selectedRange = selectedRange {
            let position =  textView.position(from: (selectedRange.start), offset: 0)
            if position != nil {
                let startOffset = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                let endOffset = textView.offset(from: textView.beginningOfDocument, to: selectedRange.end)
                let offsetRange = NSMakeRange(startOffset, endOffset - startOffset) // 高亮部分起始位置
                if offsetRange.location < maxLableCount {
                    // 高亮部分先不进行字数统计
                    return true
                } else {
                    debugPrint("字数已达上限")
                    return false
                }
            }
        }

        // 在最末添加
        if range.location >= maxLableCount {
            debugPrint("字数已达上限")
            return false
        }

        // 在其他位置添加
        if textView.text.count >= maxLableCount && range.length <  text.count {
            debugPrint("字数已达上限")
            return false
        }

        return true
    }
    
}


