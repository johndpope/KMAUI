//
//  KMAUIPreviewController.swift
//  KMAUI
//
//  Created by Sergey Glushchenko on 25.04.2020.
//

import QuickLook

public class KMAUIPreviewController: NSObject {

    fileprivate lazy var previewItem = NSURL()
    
    public func display(_ previewItem: NSURL) {
        // Display file
        self.previewItem = previewItem
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        KMAUIUtilities.shared.displayAlert(viewController: previewController)
    }
    
    @available(iOS 13.0, *)
    public class func thumbnail(_ previewItem: URL, complete: @escaping (_ image: UIImage?) -> Void) {
        let size: CGSize = CGSize(width: 128, height: 128)
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: previewItem,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .all)
        
        
        // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
            DispatchQueue.main.async {
                complete(thumbnail?.uiImage)
            }
        }
    }
}

extension KMAUIPreviewController: QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}
