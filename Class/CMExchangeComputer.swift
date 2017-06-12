//
//  CMExchangeComputer.swift
//  CMTextField
//
//  Created by CM on 2017/6/6.
//  Copyright © 2017年 CM. All rights reserved.
//

import UIKit

/**
 *  代理的标记
 */
enum DelegateFlags {
    case supportsShouldChangeTextInRange,supportsTextFieldShouldChangeCharactersInRange, supportsTextViewShouldChangeTextInRange,none
}


class CMExchangeComputer: UIView {

    //MARK: 成员变量
    @IBOutlet weak var viewSale: UIView!
    @IBOutlet weak var constraintViewSale: NSLayoutConstraint!
    @IBOutlet weak var switchBorrow: UISwitch!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var constraintViewPrice: NSLayoutConstraint!
    @IBOutlet weak var viewLine: UIView!

    @IBOutlet var button_0: UIButton!
    @IBOutlet var button_1: UIButton!
    @IBOutlet var button_2: UIButton!
    @IBOutlet var button_3: UIButton!
    @IBOutlet var button_4: UIButton!
    @IBOutlet var button_5: UIButton!
    @IBOutlet var button_6: UIButton!
    @IBOutlet var button_7: UIButton!
    @IBOutlet var button_8: UIButton!
    @IBOutlet var button_9: UIButton!
    @IBOutlet var button_dot: UIButton!
    @IBOutlet var button_hide: UIButton!
    @IBOutlet var button_del: UIButton!
    @IBOutlet var button_confirm: UIButton!

    var delegateSupportFlag: DelegateFlags = DelegateFlags.none
    var isInitial = false
    var keyboardButtons: [UIButton]!
    
    var textObj: AnyObject? {
        didSet {
            if textObj!.responds(
                to: #selector(UITextInput.shouldChangeText(in:replacementText:))) {
                self.delegateSupportFlag = DelegateFlags.supportsShouldChangeTextInRange;
                
            } else if let textInput = textObj as? UITextField {
                let delegate = textInput.delegate
                if delegate!.responds(
                    to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) {
                    self.delegateSupportFlag = DelegateFlags.supportsTextFieldShouldChangeCharactersInRange;
                }
                
            } else if let textInput = textObj as? UITextView {
                let delegate = textInput.delegate
                if delegate!.responds(
                    to: #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) {
                    self.delegateSupportFlag = DelegateFlags.supportsTextViewShouldChangeTextInRange;
                }
            } else {
                self.delegateSupportFlag = DelegateFlags.none
            }
        }
    }

    var keyboardHeight: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
            
        }
        get {
            return self.frame.size.height
        }
        
    }

    
    
    // 转入转出币
    typealias ButtonOperateCoinDoWhat = () -> Void
    var buttonOperateCoinDoWhat: ButtonOperateCoinDoWhat? {
        didSet {
            
        }
    }
    
   
    // 买入或卖出
    typealias ButtonExchangeDoWhat = () -> Void
    var buttonExchangeDoWhat: ButtonExchangeDoWhat? {
        didSet {
            
        }
    }
    
    var isHiddenViewBorrow = true {
        didSet {
            if isHiddenViewBorrow == true {
                self.viewPrice.isHidden = true
                self.constraintViewPrice.constant = 0
                self.viewLine.isHidden = false
            } else {
                self.viewPrice.isHidden = false
                self.constraintViewPrice.constant = 48
                self.viewLine.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !isInitial {
            
            //键盘按钮数组
            self.keyboardButtons = [
                button_0,
                button_1,
                button_2,
                button_3,
                button_4,
                button_5,
                button_6,
                button_7,
                button_8,
                button_9,
                button_dot,
                button_del,
                button_hide
            ]
            
            
            isInitial = true
        }
        
        
    }

    /// 转入转出币
    @IBAction func handlePressOperateCoin(_ sender: UIButton) {
        buttonOperateCoinDoWhat?()
        
    }
    
    
    ///创建实例
    class func getInstance(_ keyboardHeight: CGFloat? = nil,textObj: AnyObject? = nil) -> CMExchangeComputer {
        
        let cmExchangeComputer = UIView.loadFromNibNamed("CMExchangeComputer") as! CMExchangeComputer
        cmExchangeComputer.keyboardHeight = keyboardHeight!
        cmExchangeComputer.textObj = textObj
        cmExchangeComputer.backgroundColor = UIColor.white
        return cmExchangeComputer
        
    }
    
}

extension CMExchangeComputer {
    
    /**
     获取文本选择的范围
     
     - parameter textInput:
     
     - returns:
     */
    func selectedRange(_ textInput: UITextInput) -> NSRange {
        let textRange = textInput.selectedTextRange
        let startOffset = textInput.offset(from: textInput.beginningOfDocument, to: textRange!.start)
        let endOffset = textInput.offset(from: textInput.beginningOfDocument, to: textRange!.end)
        
        return NSMakeRange(startOffset, endOffset - startOffset);
    }
    
}

// MARK: - 按钮的功能
extension CMExchangeComputer {
    
    /**
     清除按钮
     */
    @IBAction func clearButtonPress(_ sender: UIButton?) {
        
        if let textInput = self.textObj as? UITextInput {
            
            switch self.delegateSupportFlag {
            case DelegateFlags.supportsShouldChangeTextInRange:
                var textRange = textInput.selectedTextRange
                
                if (textRange?.start == textRange?.end) {
                    let newStart = textInput.position(from: textRange!.start, in: UITextLayoutDirection.left, offset: 1)
                    textRange = textInput.textRange(from: newStart!, to: textRange!.end)
                }
                
                if textInput.shouldChangeText!(in: textRange!, replacementText:"") {
                    textInput.deleteBackward()
                }
                break
            case DelegateFlags.supportsTextFieldShouldChangeCharactersInRange:
                var selectedRange = self.selectedRange(textInput)
                if (selectedRange.length == 0 && selectedRange.location > 0) {
                    selectedRange.location -= 1;
                    selectedRange.length = 1;
                }
                let textField = textInput as! UITextField
                if textField.delegate?.textField?(textField, shouldChangeCharactersIn: selectedRange, replacementString: "") ?? false {
                    textInput.deleteBackward()
                }
                break
            case DelegateFlags.supportsTextViewShouldChangeTextInRange:
                var selectedRange = self.selectedRange(textInput)
                if (selectedRange.length == 0 && selectedRange.location > 0) {
                    selectedRange.location -= 1;
                    selectedRange.length = 1;
                }
                let textView = textInput as! UITextView
                if textView.delegate?.textView?(textView, shouldChangeTextIn: selectedRange, replacementText: "") ?? false {
                    textInput.deleteBackward()
                }
                break
            default:
                textInput.deleteBackward()
            }
            
        }
    }

    /**
     数字按钮点击
     
     - parameter sender:
     */
    @IBAction func numberButtonPress(_ sender: UIButton) {
        if let textInput = self.textObj as? UITextField {
            
            if sender === self.button_dot {
                if textInput.text!.contains(".") {    //如果包含小数.则不再输入
                    return
                }
            }
            
            var selectedRange = self.selectedRange(textInput)
            if (selectedRange.length == 0 && selectedRange.location > 0) {
                selectedRange.location -= 1;
                selectedRange.length = 1;
            }
            if textInput.delegate?.textField?(textInput, shouldChangeCharactersIn: selectedRange, replacementString: sender.titleLabel!.text!) ?? true {
                textInput.insertText(sender.titleLabel!.text!)
            }
            
        }
    }

    /**
     收回键盘按钮点击
     
     - parameter sender:
     */
    @IBAction func hideComputerKeyboard(_ sender: UIButton?) {
        if let textInput = self.textObj as? UIResponder {
            textInput.resignFirstResponder()
        }
    }

    /// 开关
    @IBAction func handleSwitchBorrow(_ sender: UISwitch) {
        
        if sender.isOn {
            isHiddenViewBorrow = false
        } else {
            isHiddenViewBorrow = true
        }
        
    }
    
    
}


// MARK: - 扩展文本输入控制可返回ExchangeComputer
extension UITextField {
    
    var exchangeComputer: CMExchangeComputer? {
        if let computer = self.inputView as? CMExchangeComputer {
            return computer
        } else {
            return nil
        }
    }
}

extension UITextView {
    
    var exchangeComputer: CMExchangeComputer? {
        if let computer = self.inputView as? CMExchangeComputer {
            return computer
        } else {
            return nil
        }
    }
}

//MARK：全局方法
extension UIView {
    
    //读取nib文件
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}


