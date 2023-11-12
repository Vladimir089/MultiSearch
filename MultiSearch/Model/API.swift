import Foundation

// Модель данных для URL-ответа от Unsplash API
struct UnsplashResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// Модель данных для фотографии
struct UnsplashPhoto: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let description: String?
    let urls: UnsplashPhotoUrls
    let links: UnsplashPhotoLinks
    let likes: Int
    let likedByUser: Bool
    let user: UnsplashUser
    let tags: [UnsplashTag]
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case description
        case urls
        case links
        case likes
        case likedByUser = "liked_by_user"
        case user
        case tags
    }
}

// Модель данных для URL-ов фотографии
struct UnsplashPhotoUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

// Модель данных для ссылок на фотографию
struct UnsplashPhotoLinks: Codable {
    let linksSelf: String
    let html: String
    let download: String
    let downloadLocation: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html
        case download
        case downloadLocation = "download_location"
    }
}

// Модель данных для пользователя, который загрузил фотографию
struct UnsplashUser: Codable {
    let id: String
    let username: String
    let name: String
    let portfolioURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case portfolioURL = "portfolio_url"
    }
}

// Модель данных для тегов
struct UnsplashTag: Codable {
    let title: String
}

