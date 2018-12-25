
public protocol AudioPlayerDelegate {
    
    func audioPlayerDidLoad(id: String)
    
    func audioPlayerDidPlay(id: String)

    func audioPlayerDidStop(id: String)
    
}
