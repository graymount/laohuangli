import SwiftUI
import Foundation

struct DataManagementView: View {
    @StateObject private var userService = UserService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingBackupAlert = false
    @State private var showingRestoreAlert = false
    @State private var showingClearDataAlert = false
    @State private var showingShareSheet = false
    @State private var backupData: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("数据管理")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("管理您的个人设置、偏好和应用数据")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: exportData) {
                        DataManagementRow(
                            icon: "square.and.arrow.up",
                            title: "导出数据",
                            subtitle: "备份个人设置和偏好",
                            color: .blue
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: { showingRestoreAlert = true }) {
                        DataManagementRow(
                            icon: "square.and.arrow.down",
                            title: "导入数据",
                            subtitle: "从备份恢复设置",
                            color: .green
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                } header: {
                    Text("备份与恢复")
                }
                
                Section {
                    DataManagementRow(
                        icon: "externaldrive",
                        title: "本地存储",
                        subtitle: getStorageInfo(),
                        color: .orange
                    )
                    
                    DataManagementRow(
                        icon: "person.crop.circle",
                        title: "个人资料",
                        subtitle: userService.userProfile != nil ? "已设置" : "未设置",
                        color: .purple
                    )
                    
                    DataManagementRow(
                        icon: "bell",
                        title: "通知设置",
                        subtitle: userService.notificationSettings.isEnabled ? "已开启" : "已关闭",
                        color: .red
                    )
                } header: {
                    Text("存储信息")
                }
                
                Section {
                    Button(action: { showingClearDataAlert = true }) {
                        DataManagementRow(
                            icon: "trash",
                            title: "清除所有数据",
                            subtitle: "重置应用到初始状态",
                            color: .red
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                } header: {
                    Text("数据清理")
                } footer: {
                    Text("清除数据将删除所有个人设置，此操作不可撤销")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("数据管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
        .alert("导出成功", isPresented: $showingBackupAlert) {
            Button("分享") {
                shareBackupData()
            }
            Button("确定", role: .cancel) { }
        } message: {
            Text("数据已准备就绪，您可以分享或保存备份文件")
        }
        .alert("导入数据", isPresented: $showingRestoreAlert) {
            Button("取消", role: .cancel) { }
            Button("确定") {
                // 这里应该实现文件选择功能
                // 在实际应用中可以使用DocumentPicker
            }
        } message: {
            Text("请选择备份文件进行数据恢复")
        }
        .alert("清除所有数据", isPresented: $showingClearDataAlert) {
            Button("取消", role: .cancel) { }
            Button("清除", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("此操作将删除所有个人设置和偏好，确定要继续吗？")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [backupData])
        }
    }
    
    private func exportData() {
        let exportData = DataExport(
            userProfile: userService.userProfile,
            notificationSettings: userService.notificationSettings,
            exportDate: Date(),
            appVersion: "1.0.0"
        )
        
        if let jsonData = try? JSONEncoder().encode(exportData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            backupData = jsonString
            showingBackupAlert = true
        }
    }
    
    private func shareBackupData() {
        showingShareSheet = true
    }
    
    private func clearAllData() {
        // 清除UserDefaults中的所有应用数据
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        // 重置服务状态
        userService.userProfile = nil
        userService.notificationSettings = NotificationSettings()
        
        dismiss()
    }
    
    private func getStorageInfo() -> String {
        let userProfileSize = userService.userProfile != nil ? "已占用" : "空"
        return "个人数据: \(userProfileSize)"
    }
}

struct DataManagementRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct DataExport: Codable {
    let userProfile: UserProfile?
    let notificationSettings: NotificationSettings
    let exportDate: Date
    let appVersion: String
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    DataManagementView()
} 