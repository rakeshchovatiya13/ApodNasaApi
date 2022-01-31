//
//  ApodInfoBean.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import Foundation

struct ErrorResponse: Codable
{
    let code: Int?
    let msg: String?
}

struct ApodInfoBean: Codable
{
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let media_type: MediaType
    let title: String?
    let url: String?
    let thumbnail_url: String?
}

enum MediaType: String, Equatable
{
    case image
    case video
}

extension MediaType: Codable
{
    public init(from decoder: Decoder) throws {
        self = try MediaType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .image
    }
}
