//
//  ProfileSetViewController.swift
//  Untitled
//
//  Created by Jaehyeok Lim on 2023/05/11.
//

import UIKit
import SnapKit

class ProfileSetViewController: RegisterRootViewController {
    
    var subViewList: [UIView] = []
    
    let datePicker = UIDatePicker()
    
    let mainTextLabel = RegisterView().mainTextLabel(setText: "프로필을\n작성해주세요.")
    let nameSubTextLabel = RegisterView().subTextLabel(setText: "사용자 이름")
    let dateSubTextLabel = RegisterView().subTextLabel(setText: "생년월일")
    let genderSubTextLabel = RegisterView().subTextLabel(setText: "성별")
    
    let nameSetTextField = RegisterView().textField(setPlaceholder: "홍길동")
    let dateTextField = RegisterView().textField(setPlaceholder: "1999년7월29일")
    
    let genderSegmentedControl = RegisterView().genderSegmentedControl()
    
    let selectUserProfileImageView = RegisterView().selectUserProfileImageView()
    
    let plusButton = AlarmView().plusButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        viewLayout()
        navigationControllerLayout()
        actionFunction()
        createDatePicker()
    }
    
    private func viewLayout() {
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalTo(90)
            make.leading.equalTo(30)
        }
        
        nameSubTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(20)
            make.leading.equalTo(30)
        }
        
        nameSetTextField.snp.makeConstraints { make in
            make.top.equalTo(nameSubTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameSubTextLabel).offset(-0.5)
            make.trailing.equalTo(-30)
            make.height.equalTo(40)
        }
        
        dateSubTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameSetTextField.snp.bottom).offset(20)
            make.leading.equalTo(30)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateSubTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateSubTextLabel).offset(-0.5)
            make.width.equalTo(155)
            make.height.equalTo(40)
        }
        
        genderSubTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(20)
            make.leading.equalTo(30)
        }
        
        genderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(genderSubTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(genderSubTextLabel).offset(-0.5)
            make.trailing.equalTo(dateTextField)
            make.height.equalTo(40)
        }
        
        selectUserProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField).offset(-15)
            make.trailing.equalTo(-30)
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(genderSegmentedControl).offset(18)
            make.leading.equalTo(selectUserProfileImageView.snp.trailing).offset(-35)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        dateTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        dateTextField.leftViewMode = .always
    }
    
    private func addSubview() {
        subViewList = [mainTextLabel, nameSubTextLabel, nameSetTextField, dateSubTextLabel, dateTextField, genderSubTextLabel, genderSegmentedControl, selectUserProfileImageView, plusButton]
        
        for uiView in subViewList {
            view.addSubview(uiView)
        }
    }
    
    private func navigationControllerLayout() {
        navigationItem.title = "프로필 작성"
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonAction))
        cancelButton.tintColor = .appTextColor
        navigationItem.leftBarButtonItem = cancelButton
        
        let nextButton = UIBarButtonItem(title: "다음", style: .done, target: self, action: #selector(nextButtonAction))
        nextButton.tintColor = .appPointColor
        navigationItem.rightBarButtonItem = nextButton
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appTextColor!]
    }
    
    private func actionFunction() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func createDatePicker() {
        let toolbar = UIToolbar()

        let saveButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonAction))

        // Toolbar 아이템 설정
        let toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            saveButton
        ]
        
        toolbar.sizeToFit()
        toolbar.items = toolbarItems
        toolbar.tintColor = .appPointColor
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.overrideUserInterfaceStyle = .unspecified
    }
    
    @objc func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "사진 선택", style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            })
        }
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonAction() {
        let rootViewController = AccountSetViewController()
        show(rootViewController, sender: nil)
    }
    
    @objc func saveButtonAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년M월d일"
        
        let dateString = dateFormatter.string(from: datePicker.date)
        dateTextField.text = dateString
        
        self.view.endEditing(true)
    }
}

extension ProfileSetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[.originalImage] as? UIImage {
            selectUserProfileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
