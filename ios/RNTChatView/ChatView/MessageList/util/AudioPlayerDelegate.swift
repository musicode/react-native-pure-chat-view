
public protocol AudioPlayerDelegate {
    
    func audioPlayerDidLoad(url: String)
    
    func audioPlayerDidPlay(url: String)

    func audioPlayerDidStop(url: String)
    
}
