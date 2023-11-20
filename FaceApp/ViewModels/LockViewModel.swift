//
//  LockViewModel.swift
//  FaceApp
//
//  Created by Esteban SEMELLIER on 20/11/2023.
//

import SwiftUI
import LocalAuthentication

class LockViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var isLocked: Bool = true
    
    // MARK: Méthodes
    func lock() {
        if !isLocked {
            isLocked.toggle()
        }
    }
    
    func unlock() {
        authenticateWithBiometrics { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                // Biometric authentication succeeded
                DispatchQueue.main.async {
                    self.isLocked = false
                }
            } else {
                // Biometric authentication failed
                if let error = error {
                    print("Biometric authentication error: \(error.localizedDescription)")
                }
                
                // Retry with alternative biometric (Touch ID)
                self.retryAlternativeBiometricAuthentication()
            }
        }
    }
    
    private func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let reason = "Unlock with Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                completion(success, error)
            }
        } else {
            // Biometrics not available or not configured
            completion(false, nil)
        }
    }
    
    private func authenticateWithTouchID(completion: @escaping (Bool, Error?) -> Void) {
            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                let reason = "Unlock with Touch ID"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    completion(success, error)
                }
            } else {
                // Touch ID not available or not configured
                completion(false, nil)
            }
        }
    
    private func retryAlternativeBiometricAuthentication() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.unlock()
            }
        }
}
