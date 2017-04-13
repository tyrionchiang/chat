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

class LoginController: UIViewController, UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate{

    var messagesController : MessagesController?
    
    
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
        button.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return button
    }()
    func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil{
                print("Custom FB Login failed:",err!)
                return
            }
            //lets login with Firebase
            self.handleFBRegister()
        }
    }
    
    
    lazy var twitterLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 85, g: 172, b: 238)
        button.setTitle("Twitter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCustomTWTRLogin), for: .touchUpInside)
        return button
    }()
    func handleCustomTWTRLogin(){
        Twitter.sharedInstance().logIn { (session, error) in
            if let err = error{
                print("Failed to login via Twitter: ", err)
                return
            }
            print("Successfully logged in under Twitter")
            
            //lets login with Firebase
            self.handleTwitterRegister(session: session!)
        }
    }

    
    lazy var googleLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 221, g: 75, b: 57)
        button.setTitle("Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        return button
    }()
    func handleCustomGoogleLogin(){
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"LoginControllerGoogleSignIn"), object:nil, queue:nil, using:handleGoogleRegister)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
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
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    
    func handleLogin(){
        activityIncidatorViewAnimating(animated: true)

        
        guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {
            print("Form is not value")
            self.activityIncidatorViewAnimating(animated: false)
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            
            //successfully logged in our user
            self.successfullyLogged()
            
        })
    }

    
    
    
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
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
        imageView.image = UIImage(named: "profileImage")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(r: 78, g: 78, b: 78)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.bd.width * 0.4 / 2
        imageView.layer.masksToBounds = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        
        return imageView
    }()


    let activityIncidatorView : UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.hidesWhenStopped = true
        aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        return aiv
    }()
    func activityIncidatorViewAnimating( animated : Bool ){
        
        if(animated){
            view.addSubview(activityIncidatorView)
            activityIncidatorView.center = view.center
            activityIncidatorView.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }else{
            activityIncidatorView.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLoginViewTap))
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
    func handleLoginViewTap() {
        view.endEditing(true)
        if !islogin {
            islogin = !islogin
            loginViewHeightAnchor?.constant = bd.height * 10
            loginTitleUILabelYAnchor?.constant = bd.height * 1.4
            socialButtonContainerView.isHidden = false
            loginInputsContainerView.isHidden = false
            loginButton.isHidden = false
            self.signupTextLabel.isHidden = true
            signupTextLabelHeightAnchor?.constant = 24
            signupTitleUILableCenterYAnchor?.constant = bd.height
            
            loginEmailTextField.text = ""
            loginPasswordTextField.text = ""
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.profileImageView.isHidden = true
            })
        }
    }
    func handleSignupViewTap() {
        view.endEditing(true)
        if islogin{
            islogin = !islogin
            loginViewHeightAnchor?.constant =  bd.height * 2
            loginTitleUILabelYAnchor?.constant = bd.height
            signupTextLabel.isHidden = false
            profileImageView.isHidden = false
            
            signupNameTextField.text = ""
            signupEmailTextField.text = ""
            signupPasswordTextField.text = ""
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (bool) in
                self.socialButtonContainerView.isHidden = true
                self.loginInputsContainerView.isHidden = true
                self.loginButton.isHidden = true

            })
        }
    }
    
    var signupTitleUILableCenterYAnchor: NSLayoutConstraint?
    var signupTextLabelHeightAnchor : NSLayoutConstraint?
    var profileImageViewHeightAnchor : NSLayoutConstraint?
    
    func setupSignupView(){
        signupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupView.topAnchor.constraint(equalTo: loginView.bottomAnchor).isActive = true
        signupView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        signupView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        let signupTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSignupViewTap))
        signupTap.delegate = self
        signupView.addGestureRecognizer(signupTap)

        
        
        signupView.addSubview(sginupTitleUILable)
        signupView.addSubview(signupTextLabel)
        signupView.addSubview(profileImageView)
        signupView.addSubview(signupInputsContainerView)
        signupView.addSubview(signupButton)

        
        setupSignupInputsContainerView()
        
        
        //ned x, y, width, height constraints
        
        sginupTitleUILable.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        signupTitleUILableCenterYAnchor = sginupTitleUILable.centerYAnchor.constraint(equalTo: signupView.topAnchor, constant: bd.height)
        signupTitleUILableCenterYAnchor?.isActive = true
        
        sginupTitleUILable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sginupTitleUILable.heightAnchor.constraint(equalToConstant: 32).isActive = true

        
        
        signupTextLabel.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        signupTextLabel.topAnchor.constraint(equalTo: sginupTitleUILable.bottomAnchor, constant: bd.height * 0.05).isActive = true
        signupTextLabel.widthAnchor.constraint(equalTo: signupView.widthAnchor).isActive = true
        signupTextLabelHeightAnchor = signupTextLabel.heightAnchor.constraint(equalToConstant: 24)
        signupTextLabelHeightAnchor?.isActive = true
        
        
        profileImageView.centerXAnchor.constraint(equalTo: signupView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: signupTextLabel.bottomAnchor, constant: bd.height * 0.4).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: bd.width * 0.4 ).isActive = true
        profileImageViewHeightAnchor = profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
        profileImageViewHeightAnchor?.isActive = true
        
        
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
        signupInputsContainerView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: bd.height * 0.3).isActive = true
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
            signupTitleUILableCenterYAnchor?.constant = bd.height * 0.9
            profileImageViewHeightAnchor?.constant = -profileImageView.frame.width
            profileImageView.isHidden = true
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
            signupTitleUILableCenterYAnchor?.constant = bd.height
            signupTextLabel.isHidden = false
            profileImageViewHeightAnchor?.constant = 0
            self.profileImageView.isHidden = false

            UIView.animate(withDuration: keyboardDuration!, animations: {
                self.view.layoutIfNeeded()
            })
        }

    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    func socialAccountLogOut(){
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        if let TWTRUserID = Twitter.sharedInstance().sessionStore.session()?.userID{
            print("Logout",TWTRUserID)
            Twitter.sharedInstance().sessionStore.logOutUserID(TWTRUserID)
        }
    }
    
}
