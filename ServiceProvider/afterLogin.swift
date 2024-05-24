//
//  afterLogin.swift
//  ServiceProvider
//
//  Created by Jonathan Kandel on 23/05/2024.
//

import SwiftUI

struct afterLogin: View {
    var body: some View {
            Text("Welcome to the Next Page!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.title)
                .navigationBarTitle("Next Page", displayMode: .inline)
        }
}

//#Preview {
//    afterLogin()
//}
