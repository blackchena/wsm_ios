    //
    //  ACFloatingTextfield.swift
    //  ACFloatingTextField
    //
    //  Created by Er Abhishek Chandani on 31/07/16.
    //  Copyright © 2016 Abhishek. All rights reserved.
    //

    import UIKit
    import PromiseKit

    @IBDesignable
    @objc open class ACFloatingTextfield: UITextField {

        fileprivate var bottomLineView : UIView?
        fileprivate var labelPlaceholder : UILabel?
        fileprivate var labelErrorPlaceholder : UILabel?
        fileprivate var showingError : Bool = false

        /// Disable Floating Label when true.
        @IBInspectable open var disableFloatingLabel : Bool = false

        /// Shake Bottom line when Showing Error ?
        @IBInspectable open var shakeLineWithError : Bool = true

        /// Change Bottom Line Color.
        @IBInspectable open var lineColor : UIColor = UIColor.black

        /// Change line color when Editing in textfield
        @IBInspectable open var selectedLineColor : UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0)

        /// Change placeholder color.
        @IBInspectable open var placeHolderColor : UIColor = UIColor.lightGray

        /// Change placeholder color while editing.
        @IBInspectable open var selectedPlaceHolderColor : UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0)

        /// Change Error Text color.
        @IBInspectable open var errorTextColor : UIColor = UIColor.red

        /// Change Error Line color.
        @IBInspectable open var errorLineColor : UIColor = UIColor.red

        //MARK:- Set Text
        override open var text: String?  {
            didSet {
                if showingError && (text ?? "").isNotEmpty {
                    self.hideErrorPlaceHolder()
                }
                floatTheLabel()
            }
        }

        override open var placeholder: String? {
            willSet {
                if newValue != "" {
                    self.labelPlaceholder?.text = newValue
                }
            }
        }

        open var errorText : String? {
            willSet {
                self.labelErrorPlaceholder?.text = newValue
            }
        }

        //MARK:- UITtextfield Draw Method Override
        override open func draw(_ rect: CGRect) {
            super.draw(rect)
            self.upadteTextField(frame: CGRect(x:self.frame.minX, y:self.frame.minY, width:rect.width, height:rect.height));
        }

        // MARK:- Loading From NIB
        override open func awakeFromNib() {
            super.awakeFromNib()
            self.initialize()
        }

        // MARK:- Intialization
        override public init(frame: CGRect) {
            super.init(frame: frame)
            self.initialize()
        }

        required public init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            self.initialize()
        }

        // MARK:- Text Rect Management
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return CGRect(x:4, y:4, width:bounds.size.width, height:bounds.size.height);
        }

        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return CGRect(x:4, y:4, width:bounds.size.width, height:bounds.size.height);
        }

        //MARK:- UITextfield Becomes First Responder
        override open func becomeFirstResponder() -> Bool {
            let result = super.becomeFirstResponder()
            self.textFieldDidBeginEditing()
            return result
        }

        //MARK:- UITextfield Resigns Responder
        override open func resignFirstResponder() -> Bool {
            let result =  super.resignFirstResponder()
            self.textFieldDidEndEditing()
            return result
        }

        //MARK:- Show Error Label
        public func showError() {
            showingError = true;
            self.showErrorPlaceHolder();
        }

        public func showErrorWithText(errorText : String) {
            self.errorText = errorText;
            showingError = true;
            self.showErrorPlaceHolder();
        }

        fileprivate var animateBlock = [BlockOperation]()
        fileprivate var isLocking = false
        fileprivate var animateShowDuration = TimeInterval.init(0.3)
        fileprivate var animateHideDuration = TimeInterval.init(0.3)
    }

    fileprivate extension ACFloatingTextfield {

        fileprivate func appendAnimationBlock(animatePromise: BlockOperation) {
            animateBlock.append(animatePromise)
            excuteSynchonizeBlockOperationAnimate()
        }

        fileprivate func excuteSynchonizeBlockOperationAnimate() {
            if !isLocking,
                let firstBlock = animateBlock.first {
                isLocking = true
                firstBlock.start()
                self.animateBlock.removeFirst()
            }
        }

        //MARK:- ACFLoating Initialzation.
        func initialize() -> Void {

            self.clipsToBounds = true

            /// Adding Bottom Line
            addBottomLine()

            /// Placeholder Label Configuration.
            addFloatingLabel()

            /// Checking Floatibility
            if self.text != nil && self.text != "" {
                self.floatTheLabel()
            }

            if showingError {
                showErrorPlaceHolder()
            }
        }

        //MARK:- ADD Bottom Line
        func addBottomLine(){

            bottomLineView?.removeFromSuperview()
            //Bottom Line UIView Configuration.
            bottomLineView = UIView(frame: CGRect(x:0, y:self.frame.height-1, width:self.frame.width, height:2))
            bottomLineView?.backgroundColor = lineColor;

            if bottomLineView != nil {
                self.addSubview(bottomLineView!)
            }
        }

        //MARK:- ADD Floating Label
        func addFloatingLabel(){

            labelPlaceholder?.removeFromSuperview()

            var placeholderText : String? = labelPlaceholder?.text
            if self.placeholder != nil && self.placeholder != "" {
                placeholderText = self.placeholder!
            }
            labelPlaceholder = UILabel(frame: CGRect(x:5, y:0, width:self.frame.size.width-5, height:self.frame.height))
            labelPlaceholder?.text = placeholderText
            labelPlaceholder?.textAlignment = self.textAlignment
            labelPlaceholder?.textColor = placeHolderColor
            labelPlaceholder?.font = self.font
            labelPlaceholder?.isHidden = true
            self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
            if labelPlaceholder != nil {
                self.addSubview(labelPlaceholder!)
            }

        }


        func addErrorPlaceholderLabel() -> Void {
            labelErrorPlaceholder?.removeFromSuperview()
            labelErrorPlaceholder = UILabel()
            labelErrorPlaceholder?.text = self.errorText
            labelErrorPlaceholder?.textAlignment = self.textAlignment
            labelErrorPlaceholder?.textColor = errorTextColor
            labelErrorPlaceholder?.font = UIFont(name: (self.font?.fontName ?? "helvetica")!, size: 12)
            labelErrorPlaceholder?.sizeToFit()
            labelErrorPlaceholder?.isHidden = true;

            if labelErrorPlaceholder != nil {
                self.addSubview(labelErrorPlaceholder!)
            }

            var frame = labelErrorPlaceholder!.frame
            frame.origin.x = self.bounds.maxX - frame.width
            labelErrorPlaceholder?.frame = frame
        }

        func showPlaceHolder() {
            if self.text != nil {
                var labelFrame = labelPlaceholder?.frame
                labelFrame?.origin.y += (labelFrame?.height ?? 0)!
                labelFrame?.origin.y += 4
                self.labelPlaceholder?.alpha = 0

                UIView.animate(withDuration: self.animateShowDuration, delay: 0, options: .curveEaseInOut, animations: {
                    self.labelPlaceholder?.frame = labelFrame!
                    self.labelPlaceholder?.alpha = 1
                }) { (finished) in
                    self.labelPlaceholder?.alpha = 1
                }
            }
        }

        func hidePlaceHolder() {
            if self.text != nil {
                var labelFrame = labelPlaceholder?.frame;
                labelFrame?.origin.y -= (labelFrame?.height ?? 0)!
                labelFrame?.origin.y -= 4

                UIView.animate(withDuration: self.animateHideDuration, delay: 0, options: .curveEaseOut, animations: {
                    self.labelPlaceholder?.frame = labelFrame!
                    self.labelPlaceholder?.alpha = 0
                }) { (finished) in
                    self.labelPlaceholder?.alpha = 0
                }
            }
        }

        func showErrorPlaceHolder() {

            var bottomLineFrame = bottomLineView?.frame
            bottomLineFrame?.origin.y = self.frame.height-2

            if self.errorText != nil && self.errorText != "" {
                self.addErrorPlaceholderLabel()

                labelErrorPlaceholder?.isHidden = false
                var frame = labelErrorPlaceholder?.frame
                frame?.origin.y = (frame?.height ?? 0)!
                labelErrorPlaceholder?.frame = frame!

                let anim = UIView.animateBlockOperation(animateWithDuration: self.animateShowDuration, delay: 0, options: .curveEaseInOut, animations: {
                    self.bottomLineView?.backgroundColor = self.errorLineColor;
                    frame?.origin.y = 0
                    self.labelErrorPlaceholder?.frame = frame!
                    self.bottomLineView?.frame  =  bottomLineFrame!;
                    self.hidePlaceHolder()
                }, finish: {
                }, completedAnim:  {
                    self.isLocking = false
                    self.excuteSynchonizeBlockOperationAnimate()
                })

                appendAnimationBlock(animatePromise: anim)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.bottomLineView?.backgroundColor = self.errorLineColor;
                    self.bottomLineView?.frame  =  bottomLineFrame!;
                }, completion: nil)
            }

            if shakeLineWithError {
                bottomLineView?.shake()
            }
        }

        //MARK:- Float & Resign
        func floatTheLabel() -> Void {

            if self.text == "" && self.isFirstResponder {

                floatPlaceHolder(selected: true)

            }else if self.text == "" && !self.isFirstResponder {

                resignPlaceholder()

            }else if self.text != "" && !self.isFirstResponder  {

                floatPlaceHolder(selected: false)

            }else if self.text != "" && self.isFirstResponder {

                floatPlaceHolder(selected: true)
            }

        }

        //MARK:- Upadate and Manage Subviews
        func upadteTextField(frame:CGRect) -> Void {
            self.frame = frame;
            self.initialize()
        }

        //MARK:- Float UITextfield Placeholder Label
        func floatPlaceHolder(selected:Bool) -> Void {

            labelPlaceholder?.isHidden = false
            self.labelPlaceholder?.alpha = 1
            var bottomLineFrame = bottomLineView?.frame
            if selected {
                bottomLineView?.backgroundColor = selectedLineColor
                self.labelPlaceholder?.textColor = self.selectedPlaceHolderColor
                bottomLineFrame?.origin.y = self.frame.height-2
                self.setValue(self.selectedPlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")

            } else {
                if !self.showingError
                {
                    bottomLineView?.backgroundColor = lineColor;
                }
                bottomLineFrame?.origin.y = self.frame.height-1
                self.labelPlaceholder?.textColor = self.placeHolderColor
                self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

            }

            if disableFloatingLabel == true {
                labelPlaceholder?.isHidden = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.bottomLineView?.frame = bottomLineFrame!
                })

                return
            }

            if !self.showingError {
                var labelFrame = labelPlaceholder?.frame
                labelFrame?.size.height = 12
                labelFrame?.origin.y = 0

                UIView.animate(withDuration: 0.2, animations: {
                    self.labelPlaceholder?.frame = labelFrame!;
                    self.labelPlaceholder?.font = UIFont(name: (self.font?.fontName)!, size: 12)

                    self.bottomLineView?.frame  =  bottomLineFrame!;
                })
            }

        }

        //MARK:- Resign the Placeholder
        func resignPlaceholder() -> Void {

            self.setValue(self.placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

            var bottomLineFrame = bottomLineView?.frame
            bottomLineFrame?.origin.y = self.frame.height-1

            bottomLineView?.backgroundColor = lineColor;

            if disableFloatingLabel {
                labelPlaceholder?.isHidden = true
                self.labelPlaceholder?.textColor = self.placeHolderColor;
                UIView.animate(withDuration: 0.2, animations: {
                    self.bottomLineView?.frame = bottomLineFrame!
                })
                return
            }

            let labelFrame = CGRect(x:5, y:0, width:self.frame.size.width-5, height:self.frame.size.height)

            UIView.animate(withDuration: 0.3, animations: {
                self.labelPlaceholder?.frame = labelFrame
                self.labelPlaceholder?.font = self.font
                self.labelPlaceholder?.textColor = self.placeHolderColor
                self.bottomLineView?.frame  =  bottomLineFrame!;
            }) { (finished) in
                if (self.text ?? "").isEmpty {
                    self.labelPlaceholder?.isHidden = true
                    self.placeholder = self.labelPlaceholder?.text
                }
            }
        }

        //MARK:- UITextField Begin Editing.
        func textFieldDidBeginEditing() -> Void {
            if showingError {
                self.hideErrorPlaceHolder()
            }
            if !self.disableFloatingLabel {
                self.placeholder = ""
            }
            self.floatTheLabel()
            self.layoutSubviews()
        }

        //MARK:- UITextField Begin Editing.
        func textFieldDidEndEditing() -> Void {
            self.floatTheLabel()
        }
    }

    //MARK:- Shake
    extension UIView {
        func shake() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.6
            animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
            layer.add(animation, forKey: "shake")
        }
    }
    
    extension ACFloatingTextfield {
        public func hideErrorPlaceHolder(){
            showingError = false
            
            if errorText == nil || errorText == "" {
                return
            }
            
            var labelErrorFrame = labelErrorPlaceholder?.frame;
            labelErrorFrame?.origin.y += (labelErrorFrame?.height ?? 0)!
            
            let anim = UIView.animateBlockOperation(animateWithDuration: self.animateHideDuration, delay: 0, animations: {
                self.labelErrorPlaceholder?.frame = labelErrorFrame!
                self.labelErrorPlaceholder?.alpha = 0
                self.showPlaceHolder()
            }, finish: {
                self.labelErrorPlaceholder?.removeFromSuperview()
            }, completedAnim: {
                self.isLocking = false
                self.excuteSynchonizeBlockOperationAnimate()
            })
            
            appendAnimationBlock(animatePromise: anim)
        }

        public func removeErrorPlaceHolder() {
            showingError = false
            self.labelErrorPlaceholder?.removeFromSuperview()
            bottomLineView?.backgroundColor = lineColor;
            bottomLineView?.frame.origin.y = self.frame.height-1
        }
    }
