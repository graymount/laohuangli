import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var userService = UserService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedBirthday = Date()
    @State private var showingSuccessAlert = false
    
    private var calculatedZodiacSign: ZodiacSign {
        userService.calculateZodiacSign(from: selectedBirthday)
    }
    
    private var calculatedChineseZodiac: ChineseZodiac {
        userService.calculateChineseZodiac(from: selectedBirthday)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 头部说明
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text("设置个人信息")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("请选择您的出生日期，我们将为您提供个性化的运势分析")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // 生日选择卡片
                    BirthdaySelectionCard(selectedBirthday: $selectedBirthday)
                    
                    // 计算结果预览
                    CalculatedInfoCard(
                        zodiacSign: calculatedZodiacSign,
                        chineseZodiac: calculatedChineseZodiac,
                        selectedDate: selectedBirthday
                    )
                    
                    // 保存按钮
                    Button(action: saveProfile) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("保存设置")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("个人设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
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

// MARK: - 生日选择卡片
struct BirthdaySelectionCard: View {
    @Binding var selectedBirthday: Date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "person.crop.circle.badge.plus")
                    .foregroundColor(.purple)
                Text("设置出生日期")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("请选择您的出生日期，用于计算个人运势")
                    .font(.body)
                    .foregroundColor(.secondary)
                
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
                
                // 显示选择的日期
                HStack {
                    Text("您的生日：")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text(dateFormatter.string(from: selectedBirthday))
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.purple.opacity(0.1))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

// MARK: - 计算信息卡片
struct CalculatedInfoCard: View {
    let zodiacSign: ZodiacSign
    let chineseZodiac: ChineseZodiac
    let selectedDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.circle")
                    .foregroundColor(.orange)
                Text("您的星座信息")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            HStack(spacing: 16) {
                // 星座信息
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.title)
                        .foregroundColor(.purple)
                    
                    Text("星座")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text(zodiacSign.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.opacity(0.1))
                )
                
                // 生肖信息
                VStack(spacing: 8) {
                    Image(systemName: "hare")
                        .font(.title)
                        .foregroundColor(.red)
                    
                    Text("生肖")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text(chineseZodiac.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.1))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

struct FeatureItem: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.body)
                .foregroundColor(.green)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProfileSetupView()
} 