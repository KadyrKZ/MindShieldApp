// APIService.swift
// Copyright © KadyrKZ. All rights reserved.

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    func upload(
        videoURL: URL,
        to serverURL: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let url = URL(string: serverURL) else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.badURL)))
            }
            return
        }

        guard let videoData = try? Data(contentsOf: videoURL) else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.cannotLoadFromNetwork)))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = createRequestBody(with: videoData, filename: videoURL.lastPathComponent, boundary: boundary)
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonResponse = jsonObject as? [String: Any] {
                        completion(.success(jsonResponse))
                    } else {
                        completion(.failure(URLError(.cannotParseResponse)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    private func createRequestBody(with videoData: Data, filename: String, boundary: String) -> Data {
        var body = Data()
        let mimetype = "video/mp4"

        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"video\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
        body.append(videoData)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))
        return body
    }
}
