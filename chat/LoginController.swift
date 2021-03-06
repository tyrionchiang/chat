//
//  LoginViewController.swift
//  chat
//
//  Created by Chiang Chuan on 26/11/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var messagesController : MessagesController?
    
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = ChatMessageCell.mainColor
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(whitColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    func handleLoginRegister(){
        
        self.activityIncidatorViewAnimating(animated: true)

        if loginRegisterSegmentControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not value")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            
            //successfully logged in our user
            self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            self.activityIncidatorViewAnimating(animated: false)
            self.dismiss(animated: true, completion: nil)

        })
    }
    
    
    
    let titleUILabel : UILabel = {
        let label = UILabel()
        label.text = "CHAT"
        label.font = UIFont(name: "SwistblnkMonthoers", size: 98)
        label.textColor = whitColor
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let whitColor = UIColor(r: 245, g: 245, b: 245)
    static let TextFieldColor = UIColor(r: 111, g: 120, b: 126)
    
    let nameTextField : UITextField = {
       let tf = UITextField()
        tf.tintColor = whitColor
        tf.textColor = whitColor
//        tf.placeholder = ""
        tf.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = TextFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = whitColor
        tf.textColor = whitColor
        tf.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = TextFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.tintColor = whitColor
        tf.textColor = whitColor
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: TextFieldColor])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = whitColor
        imageView.image = UIImage(named: "profileImage")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.75, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    
    lazy var loginRegisterSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items : ["Login", "Register"])
        sc.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(r: 161, g: 170, b: 176)], for: UIControlState.selected)
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleLoginReisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginReisterChange() {
        let title = loginRegisterSegmentControl.titleForSegment(at: loginRegisterSegmentControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Change height of inputContainerView, but how??
        inpputsContainerViewHeightAnchor?.constant = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //Change hight of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 0 : 1/3)
//        nameTextField.placeholder = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? "" : "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? "" : "Name", attributes: [NSForegroundColorAttributeName: LoginController.TextFieldColor])
        nameTextField.text = ""
        nameTextFieldHeightAnchor?.isActive = true
        
        //Change hight of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextField.text = ""
        emailTextFieldHeightAnchor?.isActive = true
        
        //Change hight of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextField.text = ""
        passwordTextFieldHeightAnchor?.isActive = true
        
        //Change height of profileImageView
        profileImageViewHeightAnchor?.constant = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 0 : 150
        
        //changr height of titleUILabel 
        titleUILabelHeightAnchor?.constant = loginRegisterSegmentControl.selectedSegmentIndex == 0 ? 150 : 0

    }
    
    let activityIncidatorView : UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.hidesWhenStopped = true
        aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
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
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(r: 51, g: 51, b: 51)
        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(titleUILabel)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentControl)
        
        
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupTitleUILabel()
        setupLoginRegisterButton()
        setupLoginReisterSegmentControl()
        
    }
    
    
    func setupLoginReisterSegmentControl(){
        //ned x, y, width, height constraints
        
        loginRegisterSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentControl.heightAnchor.constraint(equalToConstant: 37).isActive = true
    }
    
    var titleUILabelHeightAnchor : NSLayoutConstraint?
    
    func setupTitleUILabel(){
        //need x, y, width, height constrains
        titleUILabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleUILabel.bottomAnchor.constraint(equalTo: loginRegisterSegmentControl.topAnchor, constant : -12).isActive = true
        titleUILabel.widthAnchor.constraint(equalTo: loginRegisterSegmentControl.widthAnchor).isActive = true
        titleUILabelHeightAnchor = titleUILabel.heightAnchor.constraint(equalToConstant: 150)
        titleUILabelHeightAnchor?.isActive = true
    }
    
    var profileImageViewHeightAnchor : NSLayoutConstraint?
    
    func setupProfileImageView(){
        //ned x, y, width, height constraints
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentControl.topAnchor, constant : -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageViewHeightAnchor = profileImageView.heightAnchor.constraint(equalToConstant: 0)
        profileImageViewHeightAnchor?.isActive = true
    }
    
    var inpputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor : NSLayoutConstraint?
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    var passwordTextFieldHeightAnchor : NSLayoutConstraint?

    func setupInputsContainerView(){
        //ned x, y, width, height constraints
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 37).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inpputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inpputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //ned x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true

        
    }
    
    func setupLoginRegisterButton(){
        //ned x, y, width, height constraints
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.centerYAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 34).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    

}
