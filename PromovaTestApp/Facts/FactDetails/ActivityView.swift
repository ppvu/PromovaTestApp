//
//  ActivityView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 24.01.2024.
//

import Foundation
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
