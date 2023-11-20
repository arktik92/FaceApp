//
//  LockView.swift
//  FaceApp
//
//  Created by Esteban SEMELLIER on 20/11/2023.
//

import SwiftUI


struct LockView: View {
    
    @StateObject private var viewModel = LockViewModel()
    
    var body: some View {
        VStack {
            
            Image(viewModel.isLocked ? "locked" : "unlocked")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.bottom, 30)
            
            Button {
                // Action
                if viewModel.isLocked {
                    viewModel.unlock()
                } else {
                    viewModel.lock()
                }
            } label: {
                Text(viewModel.isLocked ? "Open" : "Lock")
                    .foregroundColor(.white)
                    .padding(10)
                    .background {
                        viewModel.isLocked ? Color.green : Color.red
                    }
                    .cornerRadius(15)
            }

        }
    }
}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        LockView()
    }
}
