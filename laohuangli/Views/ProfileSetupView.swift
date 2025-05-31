import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var userService = UserService.shared
    @StateObject private var calendarService = CalendarService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedBirthday = Date()
    @State private var showingSuccessAlert = false
    
    private var calculatedZodiacSign: ZodiacSign {
        userService.calculateZodiacSign(from: selectedBirthday)
    }
    
    private var calculatedChineseZodiac: ChineseZodiac {
        userService.calculateChineseZodiac(from: selectedBirthday)
    }
    
    private var lunarBirthday: LunarDate {
        calendarService.getCalendarInfo(for: selectedBirthday).lunarDate
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 头部说明
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.heroGradient)
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.primaryShadow, radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("设置个人信息")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                            
                            Text("请选择您的出生日期，我们将为您提供个性化的运势分析")
                                .font(.body)
                                .foregroundColor(.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                    
                    // 生日选择卡片
                    ModernBirthdaySelectionCard(
                        selectedBirthday: $selectedBirthday,
                        lunarBirthday: lunarBirthday
                    )
                    
                    // 计算结果预览
                    ModernCalculatedInfoCard(
                        zodiacSign: calculatedZodiacSign,
                        chineseZodiac: calculatedChineseZodiac,
                        selectedDate: selectedBirthday,
                        lunarBirthday: lunarBirthday
                    )
                    
                    // 保存按钮
                    Button(action: saveProfile) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.headline)
                            Text("保存设置")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.heroGradient)
                                .shadow(color: Color.auspiciousRed.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 16)
            }
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
            .navigationTitle("个人设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.auspiciousRed)
                }
            }
        }
        .onAppear {
            // 设置默认日期为30年前，避免选择器初始化问题
            let thirtyYearsAgo = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
            selectedBirthday = thirtyYearsAgo
        }
        .alert("设置成功", isPresented: $showingSuccessAlert) {
            Button("确定") {
                dismiss()
            }
        } message: {
            Text("您的个人信息已保存，现在可以查看专属运势分析了！")
        }
    }
    
    private func saveProfile() {
        let profile = UserProfile(
            birthday: selectedBirthday,
            zodiacSign: calculatedZodiacSign,
            chineseZodiac: calculatedChineseZodiac
        )
        
        userService.saveUserProfile(profile)
        showingSuccessAlert = true
        
        // 触发成功反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

// MARK: - 现代化生日选择卡片
struct ModernBirthdaySelectionCard: View {
    @Binding var selectedBirthday: Date
    let lunarBirthday: LunarDate
    
    private var gregorianFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 标题区域
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.heroGradient)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text("选择出生日期")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("请选择您的出生日期，我们将计算您的星座、生肖和农历生日")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .lineSpacing(2)
                
                // 日期选择器
                DatePicker(
                    "出生日期",
                    selection: $selectedBirthday,
                    in: Calendar.current.date(byAdding: .year, value: -100, to: Date())!...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // 选择日期预览区域
                VStack(spacing: 12) {
                    // 阳历生日显示
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.infoBlue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("阳历生日")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryText)
                            
                            Text(gregorianFormatter.string(from: selectedBirthday))
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryText)
                        }
                        
                        Spacer()
                        
                        Text(weekdayFormatter.string(from: selectedBirthday))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.mutedText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.appSecondaryBackground)
                            )
                    }
                    
                    Divider()
                        .background(Color.mutedText.opacity(0.3))
                    
                    // 农历生日显示
                    HStack(spacing: 12) {
                        Image(systemName: "moon.stars")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.auspiciousRed)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("农历生日")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryText)
                            
                            Text("\(lunarBirthday.year) \(lunarBirthday.month)\(lunarBirthday.day)")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryText)
                        }
                        
                        Spacer()
                        
                        if lunarBirthday.isLeapMonth {
                            Text("闰月")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.warningOrange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.warningOrange.opacity(0.15))
                                )
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appSecondaryBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.infoBlue.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - 现代化计算信息卡片
struct ModernCalculatedInfoCard: View {
    let zodiacSign: ZodiacSign
    let chineseZodiac: ChineseZodiac
    let selectedDate: Date
    let lunarBirthday: LunarDate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 标题区域
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.customGoldenYellow, .warningOrange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "star.circle")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text("您的个人信息")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                // 星座和生肖信息行
                HStack(spacing: 16) {
                    // 星座信息
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.customSoftPurple, .customRoyalBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("星座")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryText)
                            
                            Text(zodiacSign.rawValue)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.customSoftPurple.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.customSoftPurple.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    // 生肖信息
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.festiveRedGradient)
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "hare.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("生肖")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryText)
                            
                            Text(chineseZodiac.rawValue)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.auspiciousRed.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.auspiciousRed.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // 详细信息行
                VStack(spacing: 12) {
                    InfoDetailRow(
                        icon: "calendar",
                        label: "阳历生日",
                        value: formatGregorianDate(selectedDate),
                        color: .infoBlue
                    )
                    
                    InfoDetailRow(
                        icon: "moon.stars",
                        label: "农历生日", 
                        value: "\(lunarBirthday.year) \(lunarBirthday.month)\(lunarBirthday.day)\(lunarBirthday.isLeapMonth ? " (闰月)" : "")",
                        color: .auspiciousRed
                    )
                    
                    InfoDetailRow(
                        icon: "person.crop.circle",
                        label: "属相",
                        value: "\(chineseZodiac.rawValue)年",
                        color: .customJadeGreen
                    )
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appSecondaryBackground)
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private func formatGregorianDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

// MARK: - 信息详情行
struct InfoDetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryText)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ProfileSetupView()
} 