
public class BracketFilter: EmotionFilter {
    
    public init(emotionList: [Emotion]) {
        super.init(pattern: "\\[[ a-zA-Z0-9\\u4e00-\\u9fa5]+\\]", emotionList: emotionList)
    }
    
}
