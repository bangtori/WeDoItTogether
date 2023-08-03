//
//  ProfileViewController.swift
//  WeDoItTogether
//
//  Created by 방유빈 on 2023/07/14.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class ProfileViewController: UIViewController {
    let profileView = ProfileView()
    var user = UserDefaultsData.shared.getUser()
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    override func loadView() {
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons()
        setProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setProfileData()
    }
    
    override func viewDidLayoutSubviews(){
        self.setCircleImageView(imageView: profileView.profilePhotoImageView)
    }
    
    func setButtons(){
        profileView.profileEditButton.addTarget(self, action: #selector(touchUpProfileEditButton), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(touchUpLogoutButton), for: .touchUpInside)
    }
    
    // 사용자 정보 불러오기
    func setProfileData(){
        self.profileView.emailLabel.text = self.user?.email
        self.profileView.nameLabel.text = self.user?.name
        
        //이미지 불러오기
        guard let fileName = user?.profilePictureFileName else { return }
        let path = "images/images/" + fileName
        
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(imageView: (self?.profileView.profilePhotoImageView)!, url: url)
            case .failure(let error):
                print("Failed to get download url:\(error)")
            }
        }
    }
    
    // 저장된 이미지 불러오기
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
}

//MARK: - 버튼 addTarget
extension ProfileViewController {
    
    //프로필 수정 버튼 클릭
    @objc func touchUpProfileEditButton(_ sender: UIButton) {
        let profileEditViewController = ProfileEditViewController(title: "프로필 수정")
        self.navigationController?.pushViewController(profileEditViewController, animated: true)
    }
    
    //로그아웃 버튼 클릭
    @objc func touchUpLogoutButton(_ sender: UIButton){
        self.showAlert(message: "로그아웃 하시겠습니까?", isCancelButton: true) {
            do {
              try Auth.auth().signOut()
//                UserDefaultsData.shared.removeAll()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(UINavigationController(rootViewController: LoginViewController()), animated: true)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
          }
        }
    }
}
