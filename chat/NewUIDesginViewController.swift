//
//  NewUIDesginViewController.swift
//  chat
//
//  Created by Chiang Chuan on 29/03/2017.
//  Copyright © 2017 Chiang Chuan. All rights reserved.
//


import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import TwitterKit

class NewUIDesginViewController: UIViewController, UIGestureRecognizerDelegate {

    
    static let whiteColor = UIColor(r: 245, g: 245, b: 245)
    static let TextFieldColor = UIColor(r: 161, g: 170, b: 179)
    let bd = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 12) //Basic Displacement
    
    let loginView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 51, g: 51, b: 51)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signupView : UIView = {
        let view = UIView()
        view.backgroundColor = whiteColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginTitleUILable : UILabel = {
       let label = UILabel()
        label.text = "Log in"
        label.textColor = ChatMessageCell.mainColor
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sginupTitleUILable : UILabel = {
        let label = UILabel()
        label.text = "Sign up"
        label.textColor = ChatMessageCell.mainColor
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //social account Login Button
    let socialButtonContainerView : UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let socialLoginTextLabel : UILabel = {
        let label = UILabel()
        label.text = "Log in to start chat!"
        label.textColor = whiteColor
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var FBLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 59, g: 89, b: 153)
        button.setTitle("Facebook", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var twitterLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 85, g: 172, b: 238)
        button.setTitle("Twitter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var googleLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 221, g: 75, b: 57)
        button.setTitle("Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let socialSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = whiteColor
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let socialSeparatorLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(r: 51, g: 51, b: 51)
        label.text = "or"
        label.textColor = whiteColor
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //email Login 
    let loginInputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.borderWidth = 0.2
        view.layer.borderColor = TextFieldColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()

    
    
    let loginEmailTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = whiteColor
        tf.textColor = whiteColor
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
        

    let loginEmailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = TextFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginPasswordTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = whiteColor
        tf.textColor = whiteColor
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ChatMessageCell.mainColor
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitleColor(whiteColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    //email Signup
    
    let signupTextLabel : UILabel = {
        let label = UILabel()
        label.text = "Creat your account now!"
        label.textColor = TextFieldColor
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let signupInputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor(white : 0.2, alpha: 0.9).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    let signupNameTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor(r: 51, g: 51, b: 51)
        tf.textColor = UIColor(r: 51, g: 51, b: 51)
        tf.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let signupNameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = TextFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let signupEmailTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor(r: 51, g: 51, b: 51)
        tf.textColor = UIColor(r: 51, g: 51, b: 51)
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let signupEmailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = TextFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signupPasswordTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor(r: 51, g: 51, b: 51)
        tf.textColor = UIColor(r: 51, g: 51, b: 51)
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = ChatMessageCell.mainColor
        button.setTitle("Sign up", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitleColor(whiteColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Let's desgin awesome UI Login Page")
        
        view.addSubview(loginView)
        view.addSubview(signupView)

        
        setupLoginView()
        setupSignupView()
        
        setupKeyboardObservers()

    }
    
    
    var loginViewHeightAnchor : NSLayoutConstraint?
    var loginTitleUILabelYAnchor : NSLayoutConstraint?
    
    func setupLoginView(){
        // need x, y, width, height constraints
        loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loginView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginViewHeightAnchor = loginView.heightAnchor.constraint(equalToConstant: bd.height * 10)
        loginViewHeightAnchor?.isActive = true
        
        
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLoginTap))
        loginTap.delegate = self
        loginView.addGestureRecognizer(loginTap)
        
        
        
        loginView.addSubview(loginTitleUILable)
        loginView.addSubview(socialButtonContainerView)
        loginView.addSubview(loginInputsContainerView)
        loginView.addSubview(loginButton)

        
        //ned x, y, width, height constraints
        loginTitleUILable.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginTitleUILabelYAnchor = loginTitleUILable.centerYAnchor.constraint(equalTo: loginView.topAnchor, constant: bd.height * 1.4)
        loginTitleUILabelYAnchor?.isActive = true
        loginTitleUILable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loginTitleUILable.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        setupSocialButtonContainerView()
        setupLoginInputsContainerView()


        loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: loginInputsContainerView.bottomAnchor, constant: bd.height * 0.25).isActive = true
        loginButton.widthAnchor.constraint(equalTo: loginInputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: bd.height * 0.89).isActive = true
        
        
    }
    
    var islogin : Bool = true
    func handleLoginTap() {
        if !islogin {
            islogin = !islogin
            loginViewHeightAnchor?.constant = bd.height * 10
            loginTitleUILabelYAnchor?.constant = bd.height * 1.4
            socialButtonContainerView.isHidden = false
            loginInputsContainerView.isHidden = false
            loginButton.isHidden = false
            self.signupTextLabel.isHidden = true
            signupTextLabelHeightAnchor?.constant = 24
            sginupTitleUILableCenterYAnchor?.constant = bd.height
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
        view.endEditing(true)
    }
    func handleSignupTap() {
        if islogin{
            islogin = !islogin
            loginViewHeightAnchor?.constant =  bd.height * 2
            loginTitleUILabelYAnchor?.constant = bd.height
            signupTextLabel.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (bool) in
                self.socialButtonContainerView.isHidden = true
                self.loginInputsContainerView.isHidden = true
                self.loginButton.isHidden = true

            })
        }
        view.endEditing(true)
    }
    
    var sginupTitleUILableCenterYAnchor: NSLayoutConstraint?
    var signupTextLabelHeightAnchor : NSLayoutConstraint?
    
    func setupSignupView(){
        signupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupView.topAnchor.constraint(equalTo: loginView.bottomAnchor).isActive = true
        signupView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        signupView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        let signupTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSignupTap))
        signupTap.delegate = self
        signupView.addGestureRecognizer(signupTap)

        
        
        signupView.addSubview(sginupTitleUILable)
        signupView.addSubview(signupTextLabel)
        signupView.addSubview(signupInputsContainerView)
        signupView.addSubview(signupButton)

        
        setupSignupInputsContainerView()
        
        
        //ned x, y, width, height constraints
        sginupTitleUILable.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        sginupTitleUILableCenterYAnchor = sginupTitleUILable.centerYAnchor.constraint(equalTo: signupView.topAnchor, constant: bd.height)
        sginupTitleUILableCenterYAnchor?.isActive = true
        
        sginupTitleUILable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sginupTitleUILable.heightAnchor.constraint(equalToConstant: 32).isActive = true

        
        
        signupTextLabel.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        signupTextLabel.topAnchor.constraint(equalTo: sginupTitleUILable.bottomAnchor, constant: bd.height * 0.05).isActive = true
        signupTextLabel.widthAnchor.constraint(equalTo: signupView.widthAnchor).isActive = true
        signupTextLabelHeightAnchor = signupTextLabel.heightAnchor.constraint(equalToConstant: 24)
        signupTextLabelHeightAnchor?.isActive = true
        
        
        signupButton.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: signupInputsContainerView.bottomAnchor, constant: bd.height * 0.25).isActive = true
        signupButton.widthAnchor.constraint(equalTo: signupInputsContainerView.widthAnchor).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: bd.height * 0.89).isActive = true


    }
    
    
    var socialButtonContainerViewHeightAnchor : NSLayoutConstraint?
    
    func setupSocialButtonContainerView(){
        socialButtonContainerView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        socialButtonContainerView.topAnchor.constraint(equalTo: loginTitleUILable.bottomAnchor, constant: bd.height * 0.05).isActive = true
        socialButtonContainerView.widthAnchor.constraint(equalToConstant: bd.width * 0.9).isActive = true
        socialButtonContainerViewHeightAnchor = socialButtonContainerView.heightAnchor.constraint(equalToConstant: bd.height * 3.8)
        socialButtonContainerViewHeightAnchor?.isActive = true

        
        socialButtonContainerView.addSubview(socialLoginTextLabel)
        socialButtonContainerView.addSubview(FBLoginButton)
        socialButtonContainerView.addSubview(twitterLoginButton)
        socialButtonContainerView.addSubview(googleLoginButton)
        socialButtonContainerView.addSubview(socialSeparatorView)
        socialButtonContainerView.addSubview(socialSeparatorLabel)
        
        
        //need x, y, w, h, constraints
        socialLoginTextLabel.centerXAnchor.constraint(equalTo: socialButtonContainerView.centerXAnchor).isActive = true
        socialLoginTextLabel.topAnchor.constraint(equalTo: socialButtonContainerView.topAnchor).isActive = true
        socialLoginTextLabel.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        socialLoginTextLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        
        FBLoginButton.centerXAnchor.constraint(equalTo: socialButtonContainerView.centerXAnchor).isActive = true
        FBLoginButton.bottomAnchor.constraint(equalTo: twitterLoginButton.topAnchor, constant: -4).isActive = true
        FBLoginButton.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        FBLoginButton.heightAnchor.constraint(equalTo: twitterLoginButton.heightAnchor).isActive = true
        
        twitterLoginButton.centerXAnchor.constraint(equalTo: socialButtonContainerView.centerXAnchor).isActive = true
        twitterLoginButton.centerYAnchor.constraint(equalTo: socialButtonContainerView.centerYAnchor).isActive = true
        twitterLoginButton.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        twitterLoginButton.heightAnchor.constraint(equalToConstant: bd.height * 0.6).isActive = true

        googleLoginButton.centerXAnchor.constraint(equalTo: socialButtonContainerView.centerXAnchor).isActive = true
        googleLoginButton.topAnchor.constraint(equalTo: twitterLoginButton.bottomAnchor, constant: 4).isActive = true
        googleLoginButton.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        googleLoginButton.heightAnchor.constraint(equalTo: twitterLoginButton.heightAnchor).isActive = true

        socialSeparatorView.leftAnchor.constraint(equalTo: socialButtonContainerView.leftAnchor).isActive = true
        socialSeparatorView.bottomAnchor.constraint(equalTo: socialButtonContainerView.bottomAnchor, constant: -4).isActive = true
        socialSeparatorView.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        socialSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        socialSeparatorLabel.centerXAnchor.constraint(equalTo: socialSeparatorView.centerXAnchor).isActive = true
        socialSeparatorLabel.centerYAnchor.constraint(equalTo: socialSeparatorView.centerYAnchor, constant: -2).isActive = true
        socialSeparatorLabel.widthAnchor.constraint(equalToConstant: bd.width * 0.13).isActive = true
        socialSeparatorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true


    }
    
    func setupLoginInputsContainerView(){
        
        //ned x, y, width, height constraints
        loginInputsContainerView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginInputsContainerView.topAnchor.constraint(equalTo: socialButtonContainerView.bottomAnchor, constant: bd.height * 0.76).isActive = true
        loginInputsContainerView.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        loginInputsContainerView.heightAnchor.constraint(equalToConstant: bd.height * 1.6).isActive = true
        
        
        loginInputsContainerView.addSubview(loginEmailTextField)
        loginInputsContainerView.addSubview(loginEmailSeparatorView)
        loginInputsContainerView.addSubview(loginPasswordTextField)
        
        
        //ned x, y, width, height constraints
        loginEmailTextField.centerXAnchor.constraint(equalTo: loginInputsContainerView.centerXAnchor).isActive = true
        loginEmailTextField.topAnchor.constraint(equalTo: loginInputsContainerView.topAnchor).isActive = true
        loginEmailTextField.widthAnchor.constraint(equalTo: loginInputsContainerView.widthAnchor, multiplier: 0.9).isActive = true
        loginEmailTextField.heightAnchor.constraint(equalTo: loginInputsContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        loginEmailSeparatorView.centerXAnchor.constraint(equalTo: loginInputsContainerView.centerXAnchor).isActive = true
        loginEmailSeparatorView.topAnchor.constraint(equalTo: loginEmailTextField.bottomAnchor).isActive = true
        loginEmailSeparatorView.widthAnchor.constraint(equalTo: loginInputsContainerView.widthAnchor, multiplier : 0.97).isActive = true
        loginEmailSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        loginPasswordTextField.centerXAnchor.constraint(equalTo: loginInputsContainerView.centerXAnchor).isActive = true
        loginPasswordTextField.topAnchor.constraint(equalTo: loginEmailTextField.bottomAnchor).isActive = true
        loginPasswordTextField.widthAnchor.constraint(equalTo: loginEmailTextField.widthAnchor).isActive = true
        loginPasswordTextField.heightAnchor.constraint(equalTo: loginInputsContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    
    func setupSignupInputsContainerView(){
        //ned x, y, width, height constraints
        signupInputsContainerView.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        signupInputsContainerView.topAnchor.constraint(equalTo: signupTextLabel.bottomAnchor, constant: bd.height * 0.5).isActive = true
        signupInputsContainerView.widthAnchor.constraint(equalTo: socialButtonContainerView.widthAnchor).isActive = true
        signupInputsContainerView.heightAnchor.constraint(equalToConstant: bd.height * 2.4).isActive = true
        
        
        signupInputsContainerView.addSubview(signupNameTextField)
        signupInputsContainerView.addSubview(signupNameSeparatorView)
        signupInputsContainerView.addSubview(signupEmailTextField)
        signupInputsContainerView.addSubview(signupEmailSeparatorView)
        signupInputsContainerView.addSubview(signupPasswordTextField)
        
        
        //ned x, y, width, height constraints
        signupNameTextField.centerXAnchor.constraint(equalTo: signupInputsContainerView.centerXAnchor).isActive = true
        signupNameTextField.topAnchor.constraint(equalTo: signupInputsContainerView.topAnchor).isActive = true
        signupNameTextField.widthAnchor.constraint(equalTo: signupInputsContainerView.widthAnchor, multiplier: 0.9).isActive = true
        signupNameTextField.heightAnchor.constraint(equalTo: signupInputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        signupNameSeparatorView.centerXAnchor.constraint(equalTo: signupInputsContainerView.centerXAnchor).isActive = true
        signupNameSeparatorView.topAnchor.constraint(equalTo: signupNameTextField.bottomAnchor).isActive = true
        signupNameSeparatorView.widthAnchor.constraint(equalTo: signupInputsContainerView.widthAnchor, multiplier : 0.97).isActive = true
        signupNameSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        
        signupEmailTextField.centerXAnchor.constraint(equalTo: signupInputsContainerView.centerXAnchor).isActive = true
        signupEmailTextField.centerYAnchor.constraint(equalTo: signupInputsContainerView.centerYAnchor).isActive = true
        signupEmailTextField.widthAnchor.constraint(equalTo: signupInputsContainerView.widthAnchor, multiplier: 0.9).isActive = true
        signupEmailTextField.heightAnchor.constraint(equalTo: signupInputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        signupEmailSeparatorView.centerXAnchor.constraint(equalTo: signupInputsContainerView.centerXAnchor).isActive = true
        signupEmailSeparatorView.topAnchor.constraint(equalTo: signupEmailTextField.bottomAnchor).isActive = true
        signupEmailSeparatorView.widthAnchor.constraint(equalTo: signupInputsContainerView.widthAnchor, multiplier : 0.97).isActive = true
        signupEmailSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        signupPasswordTextField.centerXAnchor.constraint(equalTo: signupInputsContainerView.centerXAnchor).isActive = true
        signupPasswordTextField.topAnchor.constraint(equalTo: signupEmailTextField.bottomAnchor).isActive = true
        signupPasswordTextField.widthAnchor.constraint(equalTo: signupEmailTextField.widthAnchor).isActive = true
        signupPasswordTextField.heightAnchor.constraint(equalTo: signupInputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }

    
    
    func setupKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    func handleKeyboardWillShow(notification: NSNotification){
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        if islogin {
            socialButtonContainerView.isHidden = true
            socialButtonContainerViewHeightAnchor?.constant = 0
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            signupTextLabel.isHidden = true
            signupTextLabelHeightAnchor?.constant = 0
            sginupTitleUILableCenterYAnchor?.constant = bd.height * 0.9
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
        }

    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        if islogin{
            socialButtonContainerViewHeightAnchor?.constant = bd.height * 3.8
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (bool) in
                self.socialButtonContainerView.isHidden = false
            })
        }else{
            signupTextLabelHeightAnchor?.constant = 24
            sginupTitleUILableCenterYAnchor?.constant = bd.height
            self.signupTextLabel.isHidden = false
            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
        }

    }

    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    

}
