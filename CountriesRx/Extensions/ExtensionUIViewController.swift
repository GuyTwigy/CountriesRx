//
//  ExtensionUIViewController.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, okAction: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "אישור", style: .default) { _ in
                okAction?()
            }
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addRefreshControl(to scrollView: UIScrollView, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    func endRefreshing(scrollView: UIScrollView) {
        scrollView.refreshControl?.endRefreshing()
    }
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboardWhenTappedAround(cancelTouches: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = cancelTouches
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
