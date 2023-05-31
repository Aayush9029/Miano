//
//  Haptics+Extensions.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

extension View {
    func performHapticFeedback(_ feedback: NSHapticFeedbackManager.FeedbackPattern = .generic) {
        NSHapticFeedbackManager.defaultPerformer.perform(
            feedback,
            performanceTime: .now
        )
    }
}
