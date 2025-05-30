import SwiftUI

struct UserAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 标题部分
                    VStack(alignment: .leading, spacing: 12) {
                        Text("用户服务协议")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("最后更新：2024年5月")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("感谢您使用老黄历应用。请仔细阅读以下服务条款，使用本应用即表示您同意这些条款。")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // 协议内容
                    VStack(alignment: .leading, spacing: 20) {
                        AgreementSection(
                            title: "1. 服务说明",
                            content: """
                            老黄历应用（以下简称"本应用"）是一款提供传统黄历信息、运势分析、吉日查询等功能的移动应用程序。我们致力于为用户提供准确、实用的传统文化信息服务。
                            
                            本应用提供的信息仅供参考和娱乐，不构成任何形式的专业建议或指导。
                            """
                        )
                        
                        AgreementSection(
                            title: "2. 用户责任",
                            content: """
                            • 您承诺提供真实、准确的个人信息
                            • 不得将本应用用于任何非法或未授权的目的
                            • 不得干扰或破坏本应用的正常运行
                            • 尊重其他用户的权利和隐私
                            • 遵守所有适用的法律法规
                            """
                        )
                        
                        AgreementSection(
                            title: "3. 知识产权",
                            content: """
                            本应用的所有内容，包括但不限于文字、图片、音频、视频、软件代码等，均受知识产权法保护。未经明确授权，不得复制、修改、分发或以其他方式使用这些内容。
                            
                            用户在使用本应用时生成的个人数据归用户所有。
                            """
                        )
                        
                        AgreementSection(
                            title: "4. 隐私保护",
                            content: """
                            我们高度重视用户隐私保护。收集和使用用户信息将严格遵守相关法律法规和我们的隐私政策。
                            
                            • 仅收集提供服务所必需的信息
                            • 不会向第三方出售或租赁用户个人信息
                            • 采用行业标准的安全措施保护用户数据
                            """
                        )
                        
                        AgreementSection(
                            title: "5. 免责声明",
                            content: """
                            • 本应用提供的黄历信息、运势分析等内容仅供娱乐和参考
                            • 我们不对基于这些信息做出的决定承担任何责任
                            • 不保证服务的绝对准确性、完整性或时效性
                            • 因不可抗力因素导致的服务中断，我们不承担责任
                            """
                        )
                        
                        AgreementSection(
                            title: "6. 服务变更",
                            content: """
                            我们保留随时修改、暂停或终止本应用服务的权利。重大变更将通过应用内通知或其他适当方式告知用户。
                            
                            持续使用本应用即表示您接受服务变更。
                            """
                        )
                        
                        AgreementSection(
                            title: "7. 争议解决",
                            content: """
                            因使用本应用产生的争议，应通过友好协商解决。协商不成的，提交有管辖权的人民法院解决。
                            
                            本协议的解释和执行适用中华人民共和国法律。
                            """
                        )
                        
                        AgreementSection(
                            title: "8. 联系我们",
                            content: """
                            如果您对本协议有任何疑问或建议，请通过以下方式联系我们：
                            
                            • 应用内意见反馈功能
                            • 邮箱：support@laohuangli.app
                            
                            我们会在收到您的反馈后尽快回复。
                            """
                        )
                    }
                    
                    // 生效说明
                    VStack(alignment: .leading, spacing: 12) {
                        Divider()
                        
                        Text("协议生效")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("本协议自您首次使用本应用时生效，除非双方另有约定。我们可能会不时更新本协议，更新后的协议将在应用内发布。")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("用户协议")
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

struct AgreementSection: View {
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
    UserAgreementView()
} 