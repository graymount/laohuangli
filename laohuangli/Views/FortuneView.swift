import SwiftUI

struct FortuneView: View {
    @StateObject private var calendarService = CalendarService.shared
    @StateObject private var userService = UserService.shared
    @State private var personalFortune: PersonalFortune?
    @State private var showingProfileSetup = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            Group {
                if userService.userProfile == nil {
                    // 用户未设置生日，显示设置界面
                    ProfileSetupPrompt {
                        showingProfileSetup = true
                    }
                } else {
                    // 显示运势内容
                    FortuneContentView(
                        personalFortune: personalFortune,
                        selectedDate: $selectedDate,
                        onDateChange: loadFortune
                    )
                }
            }
            .navigationTitle("运势分析")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
            .toolbar {
                if userService.userProfile != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("设置") {
                            showingProfileSetup = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView()
        }
        .onAppear {
            if userService.userProfile != nil {
                loadFortune()
            }
        }
        .onChange(of: userService.userProfile) {
            if userService.userProfile != nil {
                loadFortune()
            }
        }
    }
    
    private func loadFortune() {
        guard let profile = userService.userProfile else { return }
        personalFortune = calendarService.getPersonalFortune(for: selectedDate, userProfile: profile)
    }
}

// MARK: - 用户资料设置提示
struct ProfileSetupPrompt: View {
    let onSetup: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "star.circle")
                .font(.system(size: 80))
                .foregroundColor(.purple)
                .opacity(0.8)
            
            VStack(spacing: 12) {
                Text("开启个人运势")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("设置您的生日信息，获取专属的每日运势分析")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button(action: onSetup) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("设置生日信息")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
            }
        }
        .padding(40)
    }
}

// MARK: - 运势内容视图
struct FortuneContentView: View {
    let personalFortune: PersonalFortune?
    @Binding var selectedDate: Date
    let onDateChange: () -> Void
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 日期选择器
                DatePickerCard(selectedDate: $selectedDate, onDateChange: onDateChange)
                
                if let fortune = personalFortune {
                    // 总体运势卡片
                    OverallFortuneCard(fortune: fortune)
                    
                    // 详细运势分析
                    DetailedFortuneCard(fortune: fortune)
                    
                    // 幸运元素
                    LuckyElementsCard(fortune: fortune)
                    
                    // 运势建议
                    FortuneAdviceCard(fortune: fortune) {
                        showingShareSheet = true
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
        .refreshable {
            onDateChange()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let fortune = personalFortune {
                ShareSheet(items: [createFortuneShareText(fortune)])
            }
        }
    }
    
    private func createFortuneShareText(_ fortune: PersonalFortune) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        let dateString = formatter.string(from: selectedDate)
        
        return """
        【\(dateString) 个人运势】
        
        总体运势：\(fortune.overall.rawValue) \(fortune.overall.emoji)
        财运：\(fortune.wealth.rawValue)
        健康：\(fortune.health.rawValue)
        事业：\(fortune.career.rawValue)
        感情：\(fortune.love.rawValue)
        
        幸运色：\(fortune.luckyColor)
        幸运数字：\(fortune.luckyNumber)
        幸运方位：\(fortune.luckyDirection)
        
        运势建议：\(fortune.advice)
        
        ——来自老黄历App
        """
    }
}

// MARK: - 日期选择卡片
struct DatePickerCard: View {
    @Binding var selectedDate: Date
    let onDateChange: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.blue)
                Text("查看运势日期")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("选择要查看运势的日期")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                DatePicker(
                    "选择日期",
                    selection: $selectedDate,
                    in: Calendar.current.date(byAdding: .month, value: -1, to: Date())!...Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .onChange(of: selectedDate) {
                    onDateChange()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

// MARK: - 总体运势卡片
struct OverallFortuneCard: View {
    let fortune: PersonalFortune
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("总体运势")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 20) {
                // 运势等级显示
                VStack(spacing: 8) {
                    Text(fortune.overall.emoji)
                        .font(.system(size: 60))
                    
                    Text(fortune.overall.rawValue)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: fortune.overall.color))
                }
                
                Spacer()
                
                // 运势描述
                VStack(alignment: .trailing, spacing: 4) {
                    FortuneRatingView(level: fortune.overall)
                    
                    Text("今日整体运势")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

// MARK: - 详细运势卡片
struct DetailedFortuneCard: View {
    let fortune: PersonalFortune
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("详细分析")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                FortuneDetailItem(
                    icon: "dollarsign.circle.fill",
                    title: "财运",
                    level: fortune.wealth,
                    color: .green
                )
                
                FortuneDetailItem(
                    icon: "heart.circle.fill",
                    title: "健康",
                    level: fortune.health,
                    color: .red
                )
                
                FortuneDetailItem(
                    icon: "briefcase.circle.fill",
                    title: "事业",
                    level: fortune.career,
                    color: .blue
                )
                
                FortuneDetailItem(
                    icon: "heart.fill",
                    title: "感情",
                    level: fortune.love,
                    color: .pink
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

// MARK: - 运势详细项目
struct FortuneDetailItem: View {
    let icon: String
    let title: String
    let level: FortuneLevel
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text(level.rawValue)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: level.color))
            
            FortuneRatingView(level: level, size: .normal)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.05))
        )
    }
}

// MARK: - 幸运元素卡片
struct LuckyElementsCard: View {
    let fortune: PersonalFortune
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("幸运元素")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                LuckyElement(
                    icon: "paintpalette.fill",
                    title: "幸运色",
                    value: fortune.luckyColor,
                    color: .orange
                )
                
                LuckyElement(
                    icon: "number.circle.fill",
                    title: "幸运数字",
                    value: "\(fortune.luckyNumber)",
                    color: .purple
                )
                
                LuckyElement(
                    icon: "location.circle.fill",
                    title: "幸运方位",
                    value: fortune.luckyDirection,
                    color: .blue
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

struct LuckyElement: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - 运势建议卡片
struct FortuneAdviceCard: View {
    let fortune: PersonalFortune
    let shareAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("运势建议")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: shareAction) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            Text(fortune.advice)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
                .lineSpacing(4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

// MARK: - 运势评级视图
struct FortuneRatingView: View {
    let level: FortuneLevel
    let size: Size
    
    enum Size {
        case normal, small
        
        var starSize: CGFloat {
            switch self {
            case .normal: return 20
            case .small: return 16
            }
        }
    }
    
    init(level: FortuneLevel, size: Size = .normal) {
        self.level = level
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Image(systemName: index < ratingStars ? "star.fill" : "star")
                    .font(.system(size: size.starSize))
                    .foregroundColor(index < ratingStars ? Color(hex: level.color) : .gray.opacity(0.3))
            }
        }
    }
    
    private var ratingStars: Int {
        switch level {
        case .excellent: return 5
        case .good: return 4
        case .average: return 3
        case .poor: return 2
        case .terrible: return 1
        }
    }
}

// MARK: - Color扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    FortuneView()
} 