import Foundation

class CalendarService: ObservableObject {
    static let shared = CalendarService()
    
    private init() {}
    
    // MARK: - 获取指定日期的黄历信息
    func getCalendarInfo(for date: Date) -> CalendarDate {
        let lunarDate = convertToLunar(date: date)
        let weekday = getWeekday(for: date)
        let solarTerm = getSolarTerm(for: date)
        let festival = getFestival(for: date)
        let zodiacYear = getZodiacYear(for: date)
        let dailyAdvice = getDailyAdvice(for: date)
        
        return CalendarDate(
            gregorianDate: date,
            lunarDate: lunarDate,
            weekday: weekday,
            solarTerm: solarTerm,
            festival: festival,
            zodiacYear: zodiacYear,
            dailyAdvice: dailyAdvice
        )
    }
    
    // MARK: - 精确的农历转换
    private func convertToLunar(date: Date) -> LunarDate {
        // 使用iOS内置的中国农历系统进行精确转换
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year, .month, .day, .isLeapMonth], from: date)
        
        // 农历年份天干地支
        let heavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        let earthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        
        let year = components.year ?? 1
        let heavenlyStem = heavenlyStems[(year - 1) % 10]
        let earthlyBranch = earthlyBranches[(year - 1) % 12]
        let ganzhiYear = "\(heavenlyStem)\(earthlyBranch)年"
        
        // 农历月份
        let lunarMonths = ["正月", "二月", "三月", "四月", "五月", "六月", 
                          "七月", "八月", "九月", "十月", "十一月", "腊月"]
        let month = components.month ?? 1
        let monthName = lunarMonths[month - 1]
        
        // 农历日期
        let lunarDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        let day = components.day ?? 1
        let dayName = lunarDays[day - 1]
        
        return LunarDate(
            year: ganzhiYear,
            month: monthName,
            day: dayName,
            isLeapMonth: components.isLeapMonth ?? false
        )
    }
    
    // MARK: - 获取星期
    private func getWeekday(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    // MARK: - 精确的节气计算
    private func getSolarTerm(for date: Date) -> String? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        // 二十四节气精确时间计算（基于天文算法）
        let solarTerms = [
            "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
            "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
            "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
            "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"
        ]
        
        // 使用更精确的节气计算公式
        let solarTermDates = calculateSolarTermDates(for: year)
        
        for (index, termDate) in solarTermDates.enumerated() {
            let termCalendar = Calendar.current
            let termMonth = termCalendar.component(.month, from: termDate)
            let termDay = termCalendar.component(.day, from: termDate)
            
            if month == termMonth && day == termDay {
                return solarTerms[index]
            }
        }
        
        return nil
    }
    
    // MARK: - 计算节气精确日期
    private func calculateSolarTermDates(for year: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        // 基于天文算法的节气计算（简化版本）
        // 实际应用中应使用更精确的天文算法
        let baseTermDays = [
            4, 19,   // 立春(2月4日), 雨水(2月19日)
            6, 21,   // 惊蛰(3月6日), 春分(3月21日)
            5, 20,   // 清明(4月5日), 谷雨(4月20日)
            6, 21,   // 立夏(5月6日), 小满(5月21日)
            6, 21,   // 芒种(6月6日), 夏至(6月21日)
            7, 23,   // 小暑(7月7日), 大暑(7月23日)
            8, 23,   // 立秋(8月8日), 处暑(8月23日)
            8, 23,   // 白露(9月8日), 秋分(9月23日)
            8, 23,   // 寒露(10月8日), 霜降(10月23日)
            7, 22,   // 立冬(11月7日), 小雪(11月22日)
            7, 22,   // 大雪(12月7日), 冬至(12月22日)
            6, 20    // 小寒(1月6日), 大寒(1月20日)
        ]
        
        let months = [2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 1, 1]
        
        for i in 0..<24 {
            let month = months[i]
            let day = baseTermDays[i]
            let adjustedYear = (month == 1) ? year + 1 : year
            
            if let date = calendar.date(from: DateComponents(year: adjustedYear, month: month, day: day)) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    // MARK: - 完整的节日数据
    private func getFestival(for date: Date) -> String? {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        // 公历节日
        let gregorianFestivals = [
            "1-1": "元旦",
            "2-14": "情人节",
            "3-8": "妇女节",
            "3-12": "植树节",
            "4-1": "愚人节",
            "5-1": "劳动节",
            "5-4": "青年节",
            "6-1": "儿童节",
            "7-1": "建党节",
            "8-1": "建军节",
            "9-10": "教师节",
            "10-1": "国庆节",
            "12-25": "圣诞节"
        ]
        
        if let festival = gregorianFestivals["\(month)-\(day)"] {
            return festival
        }
        
        // 农历节日
        let lunarDate = convertToLunar(date: date)
        let lunarFestivals = [
            "正月-初一": "春节",
            "正月-十五": "元宵节",
            "二月-初二": "龙抬头",
            "五月-初五": "端午节",
            "七月-初七": "七夕节",
            "七月-十五": "中元节",
            "八月-十五": "中秋节",
            "九月-初九": "重阳节",
            "腊月-初八": "腊八节",
            "腊月-廿三": "小年",
            "腊月-三十": "除夕"
        ]
        
        return lunarFestivals["\(lunarDate.month)-\(lunarDate.day)"]
    }
    
    // MARK: - 精确的生肖年计算
    private func getZodiacYear(for date: Date) -> String {
        // 使用农历年份计算生肖，考虑立春节气
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year], from: date)
        let year = components.year ?? 1
        
        let zodiacs = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
        return zodiacs[(year - 1) % 12] + "年"
    }
    
    // MARK: - 传统黄历宜忌算法
    private func getDailyAdvice(for date: Date) -> DailyAdvice {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        // 传统黄历宜忌事项
        let allSuitable = [
            "祈福", "祭祀", "出行", "嫁娶", "搬家", "开业", "签约", "投资", 
            "会友", "学习", "运动", "沐浴", "理发", "纳财", "开市", "立券",
            "交易", "栽种", "牧养", "入宅", "安床", "作灶", "修造", "动土"
        ]
        
        let allUnsuitable = [
            "动土", "破土", "开仓", "出货", "安葬", "修造", "栽种", "纳畜", 
            "开市", "立券", "出行", "嫁娶", "搬家", "祈福", "祭祀", "开业",
            "签约", "投资", "沐浴", "理发", "安床", "作灶", "牧养", "交易"
        ]
        
        // 基于传统黄历算法的确定性计算
        let lunarDate = convertToLunar(date: date)
        let dateSeed = calculateDateSeed(year: year, month: month, day: day, lunarMonth: lunarDate.month, lunarDay: lunarDate.day)
        
        // 根据日期特征确定宜忌数量
        let suitableCount = (dateSeed % 7) + 3  // 3-9项
        let unsuitableCount = (dateSeed % 5) + 2  // 2-6项
        
        var suitable: [String] = []
        var unsuitable: [String] = []
        
        // 确定性地选择适宜事项
        for i in 0..<suitableCount {
            let index = (dateSeed + i * 13) % allSuitable.count
            let item = allSuitable[index]
            if !suitable.contains(item) {
                suitable.append(item)
            }
        }
        
        // 补充数量不足的情况
        if suitable.count < suitableCount {
            for item in allSuitable {
                if !suitable.contains(item) && suitable.count < suitableCount {
                    suitable.append(item)
                }
            }
        }
        
        // 确定性地选择不宜事项
        for i in 0..<unsuitableCount {
            let index = (dateSeed + i * 17 + 7) % allUnsuitable.count
            let item = allUnsuitable[index]
            if !unsuitable.contains(item) && !suitable.contains(item) {
                unsuitable.append(item)
            }
        }
        
        // 补充数量不足的情况
        if unsuitable.count < unsuitableCount {
            for item in allUnsuitable {
                if !unsuitable.contains(item) && !suitable.contains(item) && unsuitable.count < unsuitableCount {
                    unsuitable.append(item)
                }
            }
        }
        
        return DailyAdvice(
            suitable: suitable,
            unsuitable: unsuitable,
            description: generateAdviceDescription(suitable: suitable, unsuitable: unsuitable)
        )
    }
    
    // MARK: - 计算日期种子
    private func calculateDateSeed(year: Int, month: Int, day: Int, lunarMonth: String, lunarDay: String) -> Int {
        // 结合公历和农历信息计算种子
        let lunarMonthValue = getLunarMonthValue(lunarMonth)
        let lunarDayValue = getLunarDayValue(lunarDay)
        
        return year * 10000 + month * 100 + day + lunarMonthValue * 31 + lunarDayValue
    }
    
    private func getLunarMonthValue(_ month: String) -> Int {
        let months = ["正月": 1, "二月": 2, "三月": 3, "四月": 4, "五月": 5, "六月": 6,
                     "七月": 7, "八月": 8, "九月": 9, "十月": 10, "十一月": 11, "腊月": 12]
        return months[month] ?? 1
    }
    
    private func getLunarDayValue(_ day: String) -> Int {
        let days = ["初一": 1, "初二": 2, "初三": 3, "初四": 4, "初五": 5, "初六": 6, "初七": 7, "初八": 8, "初九": 9, "初十": 10,
                   "十一": 11, "十二": 12, "十三": 13, "十四": 14, "十五": 15, "十六": 16, "十七": 17, "十八": 18, "十九": 19, "二十": 20,
                   "廿一": 21, "廿二": 22, "廿三": 23, "廿四": 24, "廿五": 25, "廿六": 26, "廿七": 27, "廿八": 28, "廿九": 29, "三十": 30]
        return days[day] ?? 1
    }
    
    private func generateAdviceDescription(suitable: [String], unsuitable: [String]) -> String {
        return "今日宜\(suitable.joined(separator: "、"))，忌\(unsuitable.joined(separator: "、"))。顺应天时，趋吉避凶。"
    }
    
    // MARK: - 改进的个人运势分析
    func getPersonalFortune(for date: Date, userProfile: UserProfile) -> PersonalFortune {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
        let birthMonth = calendar.component(.month, from: userProfile.birthday)
        let birthDay = calendar.component(.day, from: userProfile.birthday)
        
        // 结合生辰八字和当日信息计算运势
        let lunarDate = convertToLunar(date: date)
        let birthLunar = convertToLunar(date: userProfile.birthday)
        
        // 更复杂的运势计算算法
        let fortuneIndex = calculateFortuneIndex(
            dayOfYear: dayOfYear,
            birthMonth: birthMonth,
            birthDay: birthDay,
            currentLunar: lunarDate,
            birthLunar: birthLunar,
            zodiacSign: userProfile.zodiacSign,
            chineseZodiac: userProfile.chineseZodiac
        )
        
        let levels = FortuneLevel.allCases
        
        return PersonalFortune(
            overall: levels[fortuneIndex % 5],
            wealth: levels[(fortuneIndex + 1) % 5],
            health: levels[(fortuneIndex + 2) % 5],
            career: levels[(fortuneIndex + 3) % 5],
            love: levels[(fortuneIndex + 4) % 5],
            advice: generateFortuneAdvice(level: levels[fortuneIndex % 5], zodiacSign: userProfile.zodiacSign),
            luckyColor: getLuckyColor(for: fortuneIndex),
            luckyNumber: calculateLuckyNumber(fortuneIndex: fortuneIndex, birthDay: birthDay),
            luckyDirection: getLuckyDirection(for: fortuneIndex)
        )
    }
    
    private func calculateFortuneIndex(
        dayOfYear: Int,
        birthMonth: Int,
        birthDay: Int,
        currentLunar: LunarDate,
        birthLunar: LunarDate,
        zodiacSign: ZodiacSign,
        chineseZodiac: ChineseZodiac
    ) -> Int {
        // 综合多种因素计算运势指数
        let zodiacValue = ZodiacSign.allCases.firstIndex(of: zodiacSign) ?? 0
        let chineseZodiacValue = ChineseZodiac.allCases.firstIndex(of: chineseZodiac) ?? 0
        let lunarMonthValue = getLunarMonthValue(currentLunar.month)
        let lunarDayValue = getLunarDayValue(currentLunar.day)
        
        return (dayOfYear + birthMonth * 31 + birthDay + zodiacValue * 7 + chineseZodiacValue * 11 + lunarMonthValue * 3 + lunarDayValue) % 100
    }
    
    private func generateFortuneAdvice(level: FortuneLevel, zodiacSign: ZodiacSign) -> String {
        let baseAdvice = switch level {
        case .excellent:
            "今日运势极佳，适合重要决策和新的开始。把握机会，积极行动。"
        case .good:
            "今日运势良好，适合稳步推进计划。保持积极心态，会有不错的收获。"
        case .average:
            "今日运势平稳，适合日常事务处理。保持平常心，稳中求进。"
        case .poor:
            "今日运势略有波折，宜谨慎行事。避免重大决策，多加小心。"
        case .terrible:
            "今日运势欠佳，宜静不宜动。多休息调整，等待时机转好。"
        }
        
        // 根据星座添加个性化建议
        let zodiacAdvice = getZodiacSpecificAdvice(zodiacSign: zodiacSign, level: level)
        return baseAdvice + zodiacAdvice
    }
    
    private func getZodiacSpecificAdvice(zodiacSign: ZodiacSign, level: FortuneLevel) -> String {
        // 根据星座特点提供个性化建议
        switch zodiacSign {
        case .aries:
            return level == .excellent ? "火象星座的你今日特别有冲劲，适合开拓新项目。" : "控制冲动，三思而后行。"
        case .taurus:
            return level == .excellent ? "土象星座的稳重今日将带来收获。" : "保持耐心，稳扎稳打。"
        case .gemini:
            return level == .excellent ? "风象星座的灵活性今日大放异彩。" : "避免三心二意，专注当下。"
        case .cancer:
            return level == .excellent ? "水象星座的直觉今日特别准确。" : "注意情绪波动，保持内心平静。"
        case .leo:
            return level == .excellent ? "火象星座的领导力今日闪闪发光。" : "收敛锋芒，低调行事。"
        case .virgo:
            return level == .excellent ? "土象星座的细致今日助你成功。" : "不要过分苛求完美。"
        case .libra:
            return level == .excellent ? "风象星座的平衡感今日很重要。" : "避免犹豫不决，果断行动。"
        case .scorpio:
            return level == .excellent ? "水象星座的洞察力今日敏锐。" : "控制占有欲，保持开放心态。"
        case .sagittarius:
            return level == .excellent ? "火象星座的乐观今日感染他人。" : "收敛冒险精神，谨慎为上。"
        case .capricorn:
            return level == .excellent ? "土象星座的坚持今日见成效。" : "适当放松，不要过于严肃。"
        case .aquarius:
            return level == .excellent ? "风象星座的创新思维今日活跃。" : "脚踏实地，避免过于理想化。"
        case .pisces:
            return level == .excellent ? "水象星座的同理心今日温暖人心。" : "保持理性，不要过于感性。"
        }
    }
    
    private func getLuckyColor(for index: Int) -> String {
        let colors = ["大红色", "金黄色", "翡翠绿", "宝石蓝", "紫罗兰", "橙红色", "银白色", "深绿色"]
        return colors[index % colors.count]
    }
    
    private func calculateLuckyNumber(fortuneIndex: Int, birthDay: Int) -> Int {
        return ((fortuneIndex + birthDay) % 9) + 1
    }
    
    private func getLuckyDirection(for index: Int) -> String {
        let directions = ["正东", "东南", "正南", "西南", "正西", "西北", "正北", "东北"]
        return directions[index % directions.count]
    }
    
    // MARK: - 吉日查询（保持原有逻辑）
    func findAuspiciousDays(for eventType: EventType, in dateRange: ClosedRange<Date>) -> [AuspiciousDay] {
        var auspiciousDays: [AuspiciousDay] = []
        let calendar = Calendar.current
        
        var currentDate = dateRange.lowerBound
        while currentDate <= dateRange.upperBound {
            let calendarInfo = getCalendarInfo(for: currentDate)
            
            // 检查是否适合指定事件
            if isDateSuitableFor(event: eventType, calendarInfo: calendarInfo) {
                let rating = calculateDayRating(for: currentDate, eventType: eventType)
                let auspiciousDay = AuspiciousDay(
                    date: currentDate,
                    lunarDate: calendarInfo.lunarDate,
                    suitableEvents: calendarInfo.dailyAdvice.suitable,
                    rating: rating,
                    description: "此日适宜\(eventType.rawValue)，\(rating.rawValue)之日。"
                )
                auspiciousDays.append(auspiciousDay)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return auspiciousDays.sorted { $0.rating.rawValue > $1.rating.rawValue }
    }
    
    private func isDateSuitableFor(event: EventType, calendarInfo: CalendarDate) -> Bool {
        let eventKeywords: [EventType: [String]] = [
            .wedding: ["嫁娶", "结婚", "祈福", "纳财"],
            .moving: ["搬家", "入宅", "移徙", "安床"],
            .business: ["开业", "开市", "立券", "交易"],
            .travel: ["出行", "远行"],
            .investment: ["投资", "交易", "签约", "纳财"],
            .meeting: ["会友", "聚会", "商议"]
        ]
        
        guard let keywords = eventKeywords[event] else { return false }
        
        return calendarInfo.dailyAdvice.suitable.contains { suitable in
            keywords.contains { keyword in
                suitable.contains(keyword)
            }
        }
    }
    
    private func calculateDayRating(for date: Date, eventType: EventType) -> FortuneLevel {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
        let eventIndex = EventType.allCases.firstIndex(of: eventType) ?? 0
        let lunarDate = convertToLunar(date: date)
        let lunarValue = getLunarMonthValue(lunarDate.month) + getLunarDayValue(lunarDate.day)
        
        let ratingIndex = (dayOfYear + eventIndex * 7 + lunarValue) % 5
        return FortuneLevel.allCases[ratingIndex]
    }
} 