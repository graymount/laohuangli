import SwiftUI
import MessageUI

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackType = FeedbackType.suggestion
    @State private var feedbackContent = ""
    @State private var contactEmail = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingMailComposer = false
    @State private var canSendMail = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("意见反馈")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("您的反馈对我们很重要，帮助我们不断改进应用体验")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Picker("反馈类型", selection: $feedbackType) {
                        ForEach(FeedbackType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.displayName)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("反馈类型")
                }
                
                Section {
                    TextEditor(text: $feedbackContent)
                        .frame(minHeight: 120)
                        .padding(4)
                } header: {
                    Text("详细说明")
                } footer: {
                    Text("请详细描述您的意见或遇到的问题，这将帮助我们更好地为您服务")
                }
                
                Section {
                    TextField("您的邮箱", text: $contactEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                } header: {
                    Text("联系方式（可选）")
                } footer: {
                    Text("填写邮箱后，我们可以及时回复您的反馈")
                }
                
                Section {
                    VStack(spacing: 12) {
                        Button(action: sendEmail) {
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.blue)
                                Text("发送邮件")
                                Spacer()
                                if canSendMail {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: copyFeedback) {
                            HStack {
                                Image(systemName: "doc.on.clipboard")
                                    .foregroundColor(.orange)
                                Text("复制反馈内容")
                                Spacer()
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    Text("快速反馈")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        ContactRow(
                            icon: "envelope.circle",
                            title: "邮箱",
                            subtitle: "feedback@laohuangli.app",
                            color: .blue
                        )
                        
                        ContactRow(
                            icon: "star.circle",
                            title: "App Store 评价",
                            subtitle: "为应用评分和评论",
                            color: .orange
                        )
                        
                        ContactRow(
                            icon: "questionmark.circle",
                            title: "常见问题",
                            subtitle: "查看帮助文档",
                            color: .green
                        )
                    }
                } header: {
                    Text("其他联系方式")
                }
            }
            .navigationTitle("意见反馈")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("提交") {
                        submitFeedback()
                    }
                    .disabled(feedbackContent.isEmpty)
                }
            }
        }
        .onAppear {
            canSendMail = MFMailComposeViewController.canSendMail()
        }
        .alert("反馈提示", isPresented: $showingAlert) {
            Button("确定") { }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showingMailComposer) {
            MailComposerView(
                recipients: ["feedback@laohuangli.app"],
                subject: "老黄历应用反馈 - \(feedbackType.displayName)",
                messageBody: generateEmailBody(),
                isPresented: $showingMailComposer
            )
        }
    }
    
    private func submitFeedback() {
        guard !feedbackContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "请输入反馈内容"
            showingAlert = true
            return
        }
        
        // 这里可以添加实际的反馈提交逻辑
        // 比如发送到服务器或保存到本地等
        
        alertMessage = "感谢您的反馈！我们会仔细阅读并持续改进应用体验。"
        showingAlert = true
        
        // 清空表单
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            feedbackContent = ""
            contactEmail = ""
            dismiss()
        }
    }
    
    private func sendEmail() {
        if canSendMail {
            showingMailComposer = true
        } else {
            alertMessage = "您的设备未配置邮件应用，请手动发送邮件到：feedback@laohuangli.app"
            showingAlert = true
        }
    }
    
    private func copyFeedback() {
        let feedback = generateEmailBody()
        UIPasteboard.general.string = feedback
        
        alertMessage = "反馈内容已复制到剪贴板"
        showingAlert = true
    }
    
    private func generateEmailBody() -> String {
        let deviceInfo = """
        
        ---
        设备信息：
        设备型号：\(UIDevice.current.model)
        系统版本：\(UIDevice.current.systemVersion)
        应用版本：1.0.0
        反馈时间：\(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))
        """
        
        return """
        反馈类型：\(feedbackType.displayName)
        
        详细说明：
        \(feedbackContent)
        
        联系邮箱：\(contactEmail.isEmpty ? "未提供" : contactEmail)
        \(deviceInfo)
        """
    }
}

enum FeedbackType: String, CaseIterable {
    case bug = "bug"
    case suggestion = "suggestion"
    case feature = "feature"
    case content = "content"
    case ui = "ui"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .bug: return "问题反馈"
        case .suggestion: return "改进建议"
        case .feature: return "功能请求"
        case .content: return "内容相关"
        case .ui: return "界面体验"
        case .other: return "其他"
        }
    }
    
    var icon: String {
        switch self {
        case .bug: return "ladybug"
        case .suggestion: return "lightbulb"
        case .feature: return "plus.circle"
        case .content: return "textformat"
        case .ui: return "paintbrush"
        case .other: return "ellipsis.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .bug: return .red
        case .suggestion: return .yellow
        case .feature: return .blue
        case .content: return .green
        case .ui: return .purple
        case .other: return .gray
        }
    }
}

struct ContactRow: View {
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

struct MailComposerView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let messageBody: String
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(recipients)
        composer.setSubject(subject)
        composer.setMessageBody(messageBody, isHTML: false)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposerView
        
        init(_ parent: MailComposerView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isPresented = false
        }
    }
}

#Preview {
    FeedbackView()
} 