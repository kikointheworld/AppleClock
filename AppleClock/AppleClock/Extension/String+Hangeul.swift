//
//  String+Hanguel.swift
//  AppleClock
//
//  Created by 김선재 on 02.04.24.
//

import Foundation

extension String {
    var chosung: String? {
        guard trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            return nil
        }
        
        guard let firstChar = first, let unicodeScalar = UnicodeScalar(String(firstChar))
        else {
            return nil
        }
        guard (0xAC00 ... 0xD7AF).contains(unicodeScalar.value) else {
            return String(firstChar)
        }
        let chosungList = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
        
        //한글 Unicode = 0xAC00 + (초성 인덱스 x 21 x 28) + (중성 인덱스 x 28) + 종성 인덱스
        let chosungIndex = (unicodeScalar.value - 0xAC00) / (21 * 28)
        return chosungList[Int(chosungIndex)]
    }
}
