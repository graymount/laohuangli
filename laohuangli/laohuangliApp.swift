//
//  laohuangliApp.swift
//  laohuangli
//
//  Created by liuwnfng on 2025/5/28.
//

import SwiftUI

@main
struct laohuangliApp: App {
    @StateObject private var tabRouter = TabRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tabRouter)
        }
    }
}
