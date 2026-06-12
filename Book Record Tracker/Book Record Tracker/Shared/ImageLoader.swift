import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String) async -> UIImage? {
        // 1. check cache
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        
        // 2. validate URL
        guard let url = URL(string: urlString) else { return nil }
        
        // 3. fetch from network
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let image = UIImage(data: data) else { return nil }
        
        // 4. cache and return
        cache.setObject(image, forKey: urlString as NSString)
        return image
    }
}
