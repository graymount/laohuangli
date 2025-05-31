import SwiftUI
import UniformTypeIdentifiers

// MARK: - 分享功能扩展
extension View {
    /// 添加分享功能
    func shareSupport(for content: String) -> some View {
        self.contextMenu {
            Button(action: {
                UIPasteboard.general.string = content
            }) {
                Label("复制", systemImage: "doc.on.doc")
            }
            
            Button(action: {
                // 触发分享
            }) {
                Label("分享", systemImage: "square.and.arrow.up")
            }
        }
    }
}

// MARK: - 分享扩展主组件
struct CalendarShareView: View {
    let calendarInfo: CalendarDate
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    
    var body: some View {
        VStack(spacing: 20) {
            // 分享预览卡片
            SharePreviewCard(calendarInfo: calendarInfo)
            
            // 分享按钮组
            VStack(spacing: 12) {
                ShareButton(
                    title: "分享今日黄历",
                    icon: "square.and.arrow.up.fill",
                    color: .auspiciousRed
                ) {
                    shareItems = [generateShareText()]
                    showingShareSheet = true
                }
                
                ShareButton(
                    title: "生成图片分享",
                    icon: "photo.fill",
                    color: .customGoldenYellow
                ) {
                    shareItems = generateShareContent()
                    showingShareSheet = true
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            CalendarShareSheet(items: shareItems)
        }
    }
    
    private func generateShareText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        let dateString = formatter.string(from: calendarInfo.gregorianDate)
        
        return """
        📅 \(dateString) (\(calendarInfo.weekday))
        🌙 农历: \(calendarInfo.lunarDate.month)\(calendarInfo.lunarDate.day)
        🐲 生肖: \(calendarInfo.zodiacYear)
        
        ✅ 宜: \(calendarInfo.dailyAdvice.suitable.prefix(3).joined(separator: "、"))
        ❌ 忌: \(calendarInfo.dailyAdvice.unsuitable.prefix(3).joined(separator: "、"))
        
        #老黄历 #传统文化 #每日宜忌
        """
    }
    
    private func generateShareContent() -> [Any] {
        return [generateShareText()]
    }
}

// MARK: - 分享预览卡片
struct SharePreviewCard: View {
    let calendarInfo: CalendarDate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 日期标题
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                    
                    Text("农历 \(calendarInfo.lunarDate.month)\(calendarInfo.lunarDate.day)")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "calendar.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.auspiciousRed)
            }
            
            // 宜忌内容
            VStack(alignment: .leading, spacing: 12) {
                ShareAdviceRow(
                    title: "宜",
                    items: calendarInfo.dailyAdvice.suitable.prefix(3),
                    color: .successGreen
                )
                
                ShareAdviceRow(
                    title: "忌",
                    items: calendarInfo.dailyAdvice.unsuitable.prefix(3),
                    color: .auspiciousRed
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 EEEE"
        return formatter.string(from: calendarInfo.gregorianDate)
    }
}

// MARK: - 宜忌行组件
struct ShareAdviceRow: View {
    let title: String
    let items: ArraySlice<String>
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 24, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(items), id: \.self) { item in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(color)
                            .frame(width: 4, height: 4)
                        
                        Text(item)
                            .font(.body)
                            .foregroundColor(.primaryText)
                    }
                }
            }
            
            Spacer()
        }
    }
}

// MARK: - 分享按钮组件
struct ShareButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 分享表单 (重命名避免冲突)
struct CalendarShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        // 排除不相关的分享选项
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .openInIBooks,
            .saveToCameraRoll
        ]
        
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // 无需更新
    }
}

// MARK: - 图片生成工具 (未来扩展)
struct CalendarImageGenerator {
    static func generateShareImage(from calendarInfo: CalendarDate) -> UIImage? {
        // TODO: 实现图片生成逻辑
        return nil
    }
}

// MARK: - 社交媒体特定分享
extension CalendarShareView {
    func shareToWeChat() {
        // TODO: 微信分享集成
    }
    
    func shareToWeibo() {
        // TODO: 微博分享集成
    }
    
    func shareToQQ() {
        // TODO: QQ分享集成
    }
}

// MARK: - 分享活动自定义
class CustomShareActivity: UIActivity {
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.laohuangli.custom.share")
    }
    
    override var activityTitle: String? {
        return "自定义分享"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "square.and.arrow.up.circle.fill")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func perform() {
        // 执行自定义分享逻辑
        activityDidFinish(true)
    }
} 