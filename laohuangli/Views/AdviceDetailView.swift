import SwiftUI

struct AdviceDetailView: View {
    let advice: DailyAdvice
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 总体描述
                    VStack(alignment: .leading, spacing: 12) {
                        Text("今日总览")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(advice.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.antiqueWhite)
                            )
                    }
                    
                    // 详细宜事
                    DetailSection(
                        title: "宜事详解",
                        items: advice.suitable,
                        color: .green,
                        icon: "checkmark.circle.fill"
                    )
                    
                    // 详细忌事
                    DetailSection(
                        title: "忌事详解",
                        items: advice.unsuitable,
                        color: .red,
                        icon: "xmark.circle.fill"
                    )
                    
                    // 传统文化解读
                    TraditionalWisdomSection()
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
            .navigationTitle("宜忌详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [createShareText()])
        }
    }
    
    private func createShareText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        let dateString = formatter.string(from: Date())
        
        return """
        【\(dateString) 老黄历】
        
        \(advice.description)
        
        宜：\(advice.suitable.joined(separator: "、"))
        忌：\(advice.unsuitable.joined(separator: "、"))
        
        ——来自老黄历App
        """
    }
}

// MARK: - 详细信息区块
struct DetailSection: View {
    let title: String
    let items: [String]
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(items, id: \.self) { item in
                    AdviceItemCard(
                        text: item,
                        explanation: getExplanation(for: item),
                        color: color
                    )
                }
            }
        }
    }
    
    private func getExplanation(for item: String) -> String {
        let explanations: [String: String] = [
            "祈福": "向神明祈求福祉，适合拜佛、许愿等活动",
            "出行": "外出旅行、办事，路途平安顺利",
            "搬家": "迁移居所，乔迁新居的好日子",
            "结婚": "举办婚礼，结为夫妻的吉日",
            "开业": "开张营业，创业开店的好时机",
            "签约": "签署合同协议，商务合作",
            "投资": "投资理财，购买股票基金等",
            "会友": "拜访朋友，社交聚会",
            "学习": "读书学习，考试培训",
            "运动": "体育锻炼，健身活动",
            "动土": "建筑施工，挖掘土地",
            "破土": "开工建设，破土动工",
            "开仓": "开启仓库，大宗交易",
            "出货": "货物出库，商品销售",
            "安葬": "丧葬仪式，入土为安",
            "修造": "修建房屋，装修改造",
            "栽种": "种植花草树木",
            "纳畜": "购买牲畜，养殖动物",
            "开市": "开市交易，商业活动",
            "立券": "订立契约，法律文书"
        ]
        
        return explanations[item] ?? "传统黄历中的重要事项"
    }
}

// MARK: - 宜忌项目卡片
struct AdviceItemCard: View {
    let text: String
    let explanation: String
    let color: Color
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(text)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Spacer()
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            if isExpanded {
                Text(explanation)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1))
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

// MARK: - 传统文化解读
struct TraditionalWisdomSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.orange)
                Text("传统文化")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                WisdomCard(
                    title: "黄历的由来",
                    content: "黄历又称皇历，是古代帝王遵循的一个行为规范的书籍，由钦天监计算颁布，因此也称皇历。现在我们使用的黄历，能够同时显示公历、农历和干支历等多套历法。"
                )
                
                WisdomCard(
                    title: "宜忌的意义",
                    content: "宜忌是根据天体运行规律、阴阳五行学说等传统理论推算出的每日适宜和不适宜进行的活动。虽然现代科学无法证实其准确性，但作为传统文化的一部分，仍有其参考价值。"
                )
            }
        }
    }
}

struct WisdomCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
                .lineSpacing(4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.05))
        )
    }
}

#Preview {
    AdviceDetailView(advice: DailyAdvice.sample)
} 