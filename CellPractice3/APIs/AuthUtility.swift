//
//  AuthUtility.swift
//  CellPractice3
//
//  Created by admin29 on 07/03/25.
//


import UIKit

class AuthUtility {
    
    static let shared = AuthUtility()
    
    private init() {}
    
    // MARK: - OTP Handling
    
    func sendOtp(to mobileNumber: String, completion: @escaping (Bool, String?) -> Void) {
        // Simulate OTP sending (replace with actual API call)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(true, nil)
        }
    }
    
    func verifyOtp(mobileNumber: String, otp: String, completion: @escaping (Bool, String?) -> Void) {
        // Simulate OTP verification (replace with actual API call)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if otp == "1234" { // Simulate a valid OTP
                completion(true, nil)
            } else {
                completion(false, "Invalid OTP.")
            }
        }
    }
    
    // MARK: - Alert Handling
    
    func showAlert(on viewController: UIViewController, message: String, title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
