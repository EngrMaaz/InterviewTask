//
//  BaseViewController.swift
//  InterviewTask
//
//  Created by HAPPY on 11/12/2020.
//

import UIKit

class BaseViewController: UIViewController {
        
    private var progressHUD: ProgressHUD?
    
    var isProgressing: Bool {
        return self.progressHUD != nil
    }
    
    func showProgressHUD(text: String = "Loading") {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.progressHUD = ProgressHUD(text: text)
            self.view.addSubview(self.progressHUD!)
        }
    }
    
    func hideProgressHUD() {
        guard let progressHUD = self.progressHUD else { return }

        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            self.progressHUD = nil
        }
    }
    
    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }

    func showAlert(message: String, title: String? = nil, action: UIAlertAction? = nil, secondAction: UIAlertAction? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            alertController.addAction(action ?? UIAlertAction(title: "OK", style: .default, handler: nil))
            
            if let secondAction = secondAction {
                alertController.addAction(secondAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
