public
extension OSIdentifier
{
    var simplifiedTitle: String
    {
        switch self
        {
        case .iOS:
            return String(describing: Mobile.self)
            
        case .watchOS:
            return String(describing: Watch.self)
            
        case .tvOS:
            return String(describing: TV.self)
            
        case .macOS:
            return String(describing: Desktop.self)
            
        }
    }
    
}
