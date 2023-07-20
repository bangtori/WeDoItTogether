//
//  UIViewController+Extensions.swift
//  WeDoItTogether
//
//  Created by 최하늘 on 2023/07/20.
//

import Foundation
import UIKit

extension UIViewController {
    //배경 탭하면 키보드 내리기
    func tappedDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //키보드를 내리는 메서드
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //알림창 띄우기
    func showAlert(message: String, yesAction: (() -> Void)?) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "확인", style: .default) {_ in
            yesAction?()
        }
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
    }
}