//
//  ImageItem.swift
//  Camera
//
//  Created by Ahmet Bostanci on 30.06.2025.
//

import SwiftUI
import PhotosUI

struct ImageItem: Identifiable, Hashable {
    let id = UUID()
    var pickerItem: PhotosPickerItem?
    var image: UIImage?
    
    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
