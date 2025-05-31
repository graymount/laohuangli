import Foundation

// MARK: - 日期信息模型
struct CalendarDate {
    let gregorianDate: Date
    let lunarDate: LunarDate
    let weekday: String
    let solarTerm: String?
    let festival: String?
    let zodiacYear: String
    let dailyAdvice: DailyAdvice
}

// MARK: - 农历日期
struct LunarDate {
    let year: String
    let month: String
    let day: String
    let isLeapMonth: Bool
}

// MARK: - 每日宜忌
struct DailyAdvice {
    let suitable: [String] // 宜
    let unsuitable: [String] // 忌
    let description: String
    
    static let sample = DailyAdvice(
        suitable: ["祈福", "出行", "搬家", "结婚", "开业"],
        unsuitable: ["动土", "破土", "开仓", "出货"],
        description: "今日宜祈福、出行、搬家、结婚、开业，忌动土、破土、开仓、出货。顺应天时，趋吉避凶。"
    )
}

// MARK: - 个人运势（增强版）
struct PersonalFortune {
    let overall: FortuneLevel
    let wealth: FortuneLevel
    let health: FortuneLevel
    let career: FortuneLevel
    let love: FortuneLevel
    let advice: String
    let luckyColor: String
    let luckyNumber: Int
    let luckyDirection: String
    
    // 新增：更深层的生日分析
    let birthElement: FiveElement
    let dailyElement: FiveElement
    let elementCompatibility: ElementCompatibility
    let birthNumber: Int // 生日数字学
    let lifePath: LifePath
    let personalizedAdvice: PersonalizedAdvice
    let biorhythm: Biorhythm // 生物节律
}

// MARK: - 运势等级
enum FortuneLevel: String, CaseIterable {
    case excellent = "大吉"
    case good = "吉"
    case average = "平"
    case poor = "凶"
    case terrible = "大凶"
    
    var color: String {
        switch self {
        case .excellent: return "#FF6B6B"
        case .good: return "#4ECDC4"
        case .average: return "#45B7D1"
        case .poor: return "#FFA07A"
        case .terrible: return "#96CEB4"
        }
    }
    
    var emoji: String {
        switch self {
        case .excellent: return "🌟"
        case .good: return "✨"
        case .average: return "⭐"
        case .poor: return "💫"
        case .terrible: return "🌙"
        }
    }
}

// MARK: - 吉日查询
struct AuspiciousDay {
    let date: Date
    let lunarDate: LunarDate
    let suitableEvents: [String]
    let rating: FortuneLevel
    let description: String
}

// MARK: - 事件类型
enum EventType: String, CaseIterable {
    case wedding = "结婚"
    case moving = "搬家"
    case business = "开业"
    case travel = "出行"
    case investment = "投资"
    case meeting = "会议"
    
    var icon: String {
        switch self {
        case .wedding: return "heart.fill"
        case .moving: return "house.fill"
        case .business: return "building.2.fill"
        case .travel: return "airplane"
        case .investment: return "dollarsign.circle.fill"
        case .meeting: return "person.3.fill"
        }
    }
}

// MARK: - 用户信息
struct UserProfile: Equatable, Codable {
    let birthday: Date
    let zodiacSign: ZodiacSign
    let chineseZodiac: ChineseZodiac
}

// MARK: - 星座
enum ZodiacSign: String, CaseIterable, Codable {
    case aries = "白羊座"
    case taurus = "金牛座"
    case gemini = "双子座"
    case cancer = "巨蟹座"
    case leo = "狮子座"
    case virgo = "处女座"
    case libra = "天秤座"
    case scorpio = "天蝎座"
    case sagittarius = "射手座"
    case capricorn = "摩羯座"
    case aquarius = "水瓶座"
    case pisces = "双鱼座"
}

// MARK: - 生肖
enum ChineseZodiac: String, CaseIterable, Codable {
    case rat = "鼠"
    case ox = "牛"
    case tiger = "虎"
    case rabbit = "兔"
    case dragon = "龙"
    case snake = "蛇"
    case horse = "马"
    case goat = "羊"
    case monkey = "猴"
    case rooster = "鸡"
    case dog = "狗"
    case pig = "猪"
}

// MARK: - 五行属性
enum FiveElement: String, CaseIterable {
    case wood = "木"
    case fire = "火"
    case earth = "土"
    case metal = "金"
    case water = "水"
    
    var characteristics: String {
        switch self {
        case .wood: return "生长、向上、条达、舒畅"
        case .fire: return "炎热、向上、光明、积极"
        case .earth: return "承载、生化、厚重、包容"
        case .metal: return "清洁、收敛、肃杀、坚固"
        case .water: return "寒冷、向下、滋润、闭藏"
        }
    }
    
    var luckyColors: [String] {
        switch self {
        case .wood: return ["绿色", "青色", "翠绿"]
        case .fire: return ["红色", "紫色", "橙色"]
        case .earth: return ["黄色", "棕色", "土色"]
        case .metal: return ["白色", "金色", "银色"]
        case .water: return ["黑色", "蓝色", "深蓝"]
        }
    }
    
    var supportedBy: FiveElement {
        switch self {
        case .wood: return .water
        case .fire: return .wood
        case .earth: return .fire
        case .metal: return .earth
        case .water: return .metal
        }
    }
    
    var supports: FiveElement {
        switch self {
        case .wood: return .fire
        case .fire: return .earth
        case .earth: return .metal
        case .metal: return .water
        case .water: return .wood
        }
    }
    
    var restrainedBy: FiveElement {
        switch self {
        case .wood: return .metal
        case .fire: return .water
        case .earth: return .wood
        case .metal: return .fire
        case .water: return .earth
        }
    }
}

// MARK: - 五行相配性
enum ElementCompatibility: String {
    case veryGood = "五行相生，大吉"
    case good = "五行和谐，吉"
    case neutral = "五行平衡，平"
    case poor = "五行相克，凶"
    case veryPoor = "五行严重冲突，大凶"
    
    var color: String {
        switch self {
        case .veryGood: return "#4CAF50"
        case .good: return "#8BC34A"
        case .neutral: return "#FFC107"
        case .poor: return "#FF9800"
        case .veryPoor: return "#F44336"
        }
    }
    
    var advice: String {
        switch self {
        case .veryGood: return "今日五行能量极佳，适合重要决策和新的开始"
        case .good: return "五行和谐，适合稳步推进计划"
        case .neutral: return "五行平衡，保持现状，稳中求进"
        case .poor: return "五行有冲突，宜谨慎行事，避免冲动"
        case .veryPoor: return "五行严重不和，建议静养，等待时机"
        }
    }
}

// MARK: - 生命路径数
enum LifePath: Int, CaseIterable {
    case one = 1, two = 2, three = 3, four = 4, five = 5
    case six = 6, seven = 7, eight = 8, nine = 9
    
    var meaning: String {
        switch self {
        case .one: return "领导者 - 独立、创新、开拓"
        case .two: return "合作者 - 和谐、协作、平衡"
        case .three: return "创造者 - 艺术、表达、乐观"
        case .four: return "建设者 - 稳定、实用、踏实"
        case .five: return "冒险者 - 自由、变化、多样"
        case .six: return "照顾者 - 责任、爱心、治愈"
        case .seven: return "智者 - 分析、精神、内省"
        case .eight: return "成就者 - 权力、物质、成功"
        case .nine: return "奉献者 - 人道、服务、完成"
        }
    }
    
    var todayAdvice: String {
        switch self {
        case .one: return "发挥你的领导才能，主动出击"
        case .two: return "注重团队合作，寻求平衡"
        case .three: return "发挥创意，保持乐观心态"
        case .four: return "脚踏实地，稳步前进"
        case .five: return "拥抱变化，探索新可能"
        case .six: return "关爱他人，承担责任"
        case .seven: return "深入思考，寻求内在智慧"
        case .eight: return "专注目标，追求成就"
        case .nine: return "服务他人，完成使命"
        }
    }
}

// MARK: - 个性化建议
struct PersonalizedAdvice {
    let zodiacAdvice: String
    let chineseZodiacAdvice: String
    let elementAdvice: String
    let numerologyAdvice: String
    let combinedAdvice: String
}

// MARK: - 生物节律
struct Biorhythm {
    let physical: Double // 体力周期 (23天)
    let emotional: Double // 情感周期 (28天)
    let intellectual: Double // 智力周期 (33天)
    
    var physicalLevel: BiorhythmLevel {
        return getBiorhythmLevel(physical)
    }
    
    var emotionalLevel: BiorhythmLevel {
        return getBiorhythmLevel(emotional)
    }
    
    var intellectualLevel: BiorhythmLevel {
        return getBiorhythmLevel(intellectual)
    }
    
    private func getBiorhythmLevel(_ value: Double) -> BiorhythmLevel {
        switch value {
        case 0.8...1.0: return .veryHigh
        case 0.3...0.8: return .high
        case -0.3...0.3: return .neutral
        case -0.8...(-0.3): return .low
        default: return .veryLow
        }
    }
}

enum BiorhythmLevel: String {
    case veryHigh = "极佳"
    case high = "良好"
    case neutral = "平稳"
    case low = "较低"
    case veryLow = "低迷"
    
    var color: String {
        switch self {
        case .veryHigh: return "#4CAF50"
        case .high: return "#8BC34A"
        case .neutral: return "#FFC107"
        case .low: return "#FF9800"
        case .veryLow: return "#F44336"
        }
    }
} 