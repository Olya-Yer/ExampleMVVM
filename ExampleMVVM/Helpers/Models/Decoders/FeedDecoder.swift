//
//  FeedDecoder.swift
//  ExampleMVVM
//
//  Created by Olya Yeritspokhyan on 29.01.23.
//

import Foundation

struct PostItem {
    let imageURL: String
    let size: Double
    let type: String
    let tags: String
    let userName: String
    let userImageURL: String
    let numberOfViews: Int
    let numberOfLikes: Int
    let numberOfComments: Int
    let numberOfDownloads: Int
}

struct PostPage {
    let posts: [PostItem]
    let total: Int
    let page: Int
}

class FeedDecoder {
    let decoder = JSONDecoder()
    
    func decode(data: Data) -> PostPage {
        let feed = try? decoder.decode(Feed.self, from: data)
        guard let feed = feed else { return PostPage(posts: [], total: 0, page: 1) }
        let posts = feed.hits.map(PostItem.init)
        return PostPage(posts: posts, total: 200, page: 1)
    }
}

struct Feed: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [Hit]
}

struct Hit: Decodable {
//    let imageURL: String // not available before access granted
    let imageSize: Double
    let type: String
    let tags: String
    let user: String
    let userImageURL: String
    let views: Int
    let likes: Int
    let comments: Int
    let downloads: Int
}

extension PostItem {
    init(_ data: Hit) {
        imageURL = "https://picsum.photos/200/300"
        size = data.imageSize
        type = data.type
        tags = data.tags
        userName = data.user
        userImageURL = data.userImageURL
        numberOfViews = data.views
        numberOfLikes = data.likes
        numberOfComments = data.comments
        numberOfDownloads = data.downloads
    }
}
