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

// MARK: - 个人运势
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