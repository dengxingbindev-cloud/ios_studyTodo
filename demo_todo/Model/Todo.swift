import Foundation

struct Todo: Codable {

    /// 唯一标识
    let id: UUID

    /// 待办内容
    var title: String

    /// 是否完成
    var isCompleted: Bool

    /// 创建时间
    let createTime: Date

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createTime = Date()
    }
}
