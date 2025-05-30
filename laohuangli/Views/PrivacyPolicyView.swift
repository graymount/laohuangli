import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 标题部分
                    VStack(alignment: .leading, spacing: 12) {
                        Text("隐私保护政策")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("最后更新：2024年5月")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("我们深知个人信息对您的重要性，并会尽全力保护您的个人信息安全可靠。我们承诺严格遵守相关法律法规，采取相应的安全保护措施，保护您的个人信息。")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // 政策内容
                    VStack(alignment: .leading, spacing: 20) {
                        PrivacySection(
                            title: "1. 信息收集",
                            content: """
                            我们仅会收集以下类型的信息：
                            
                            个人资料信息：
                            • 生日信息（用于运势分析）
                            • 星座和生肖信息（自动计算得出）
                            
                            使用偏好：
                            • 通知设置偏好
                            • 应用内设置选项
                            
                            技术信息：
                            • 设备型号和系统版本（用于兼容性）
                            • 应用使用统计（匿名数据）
                            
                            我们不会收集您的姓名、联系方式、位置信息或其他敏感个人信息。
                            """
                        )
                        
                        PrivacySection(
                            title: "2. 信息使用",
                            content: """
                            我们收集的信息仅用于以下目的：
                            
                            • 提供个性化的运势分析服务
                            • 改善应用功能和用户体验
                            • 发送您订阅的通知提醒
                            • 进行匿名的使用统计分析
                            • 解决技术问题和提供客户支持
                            
                            我们承诺不会将您的个人信息用于任何商业推广或营销目的。
                            """
                        )
                        
                        PrivacySection(
                            title: "3. 信息存储",
                            content: """
                            数据存储方式：
                            • 所有个人数据仅存储在您的设备本地
                            • 我们不会将您的个人信息上传到远程服务器
                            • 使用iOS系统的安全存储机制保护数据
                            
                            数据保留期限：
                            • 数据将保留至您删除应用或清除数据
                            • 您可以随时在设置中删除所有个人数据
                            """
                        )
                        
                        PrivacySection(
                            title: "4. 信息共享",
                            content: """
                            我们承诺：
                            
                            • 绝不向任何第三方出售您的个人信息
                            • 绝不向任何第三方租赁您的个人信息
                            • 不会与任何第三方共享您的个人信息
                            
                            例外情况：
                            除非您明确同意，或法律法规要求，我们不会向任何第三方披露您的个人信息。
                            """
                        )
                        
                        PrivacySection(
                            title: "5. 数据安全",
                            content: """
                            我们采取以下措施保护您的数据安全：
                            
                            技术措施：
                            • 使用iOS系统提供的安全存储API
                            • 数据加密存储在设备本地
                            • 定期进行安全更新和漏洞修复
                            
                            管理措施：
                            • 严格的内部数据访问控制
                            • 定期的安全培训和审查
                            • 安全事件响应机制
                            """
                        )
                        
                        PrivacySection(
                            title: "6. 您的权利",
                            content: """
                            您对个人信息享有以下权利：
                            
                            • 知情权：了解我们如何收集和使用您的信息
                            • 访问权：查看我们存储的您的个人信息
                            • 更正权：更新或修改不准确的个人信息
                            • 删除权：要求删除您的个人信息
                            • 拒绝权：拒绝特定的信息处理活动
                            
                            行使权利：
                            您可以通过应用内的设置功能行使上述权利，或通过意见反馈联系我们。
                            """
                        )
                        
                        PrivacySection(
                            title: "7. 第三方服务",
                            content: """
                            本应用可能使用以下第三方服务：
                            
                            • iOS系统服务（通知、日历等）
                            • App Store（应用分发）
                            
                            这些服务有各自的隐私政策，我们建议您查阅相关政策了解详情。我们不会主动向这些服务提供您的个人信息。
                            """
                        )
                        
                        PrivacySection(
                            title: "8. 儿童隐私",
                            content: """
                            我们不会故意收集13岁以下儿童的个人信息。如果我们发现无意中收集了此类信息，会立即删除。
                            
                            如果您是儿童的父母或监护人，发现儿童向我们提供了个人信息，请联系我们，我们会立即删除相关信息。
                            """
                        )
                        
                        PrivacySection(
                            title: "9. 政策更新",
                            content: """
                            我们可能会不时更新本隐私政策。更新后的政策将在应用内发布，并标注更新日期。
                            
                            重大变更时，我们会通过应用内通知或其他适当方式告知您。继续使用本应用即表示您接受更新后的政策。
                            """
                        )
                        
                        PrivacySection(
                            title: "10. 联系我们",
                            content: """
                            如果您对本隐私政策有任何疑问或建议，请通过以下方式联系我们：
                            
                            • 应用内意见反馈功能
                            • 邮箱：privacy@laohuangli.app
                            
                            我们承诺在收到您的反馈后7个工作日内回复。
                            """
                        )
                    }
                    
                    // 承诺声明
                    VStack(alignment: .leading, spacing: 12) {
                        Divider()
                        
                        Text("我们的承诺")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("保护您的隐私是我们的责任。我们承诺持续改进隐私保护措施，确保您的个人信息安全。您的信任是我们最宝贵的财富。")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("隐私政策")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PrivacySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
}

#Preview {
    PrivacyPolicyView()
} 