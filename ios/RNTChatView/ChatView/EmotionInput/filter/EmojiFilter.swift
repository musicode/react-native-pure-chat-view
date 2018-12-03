
public class EmojiFilter: EmotionFilter {
    
    public init(emotionList: [Emotion]) {
        let codes = emotionList.map { emotion in
            return emotion.code
        }
        super.init(pattern: "[\(codes.joined())]", emotionList: emotionList)
    }
    
}
