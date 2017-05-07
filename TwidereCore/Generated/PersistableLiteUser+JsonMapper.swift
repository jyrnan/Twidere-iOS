// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import PMJackson

extension PersistableLiteUser: JsonMappable {

}

public class PersistableLiteUserJsonMapper: JsonMapper<PersistableLiteUser> {

    public static let singleton = PersistableLiteUserJsonMapper()

    override public func parse(_ parser: JsonParser) -> PersistableLiteUser! {
        let instance = PersistableLiteUser()
        if (parser.currentEvent == nil) {
            parser.nextEvent()
        }

        if (parser.currentEvent != .objectStart) {
            parser.skipChildren()
            return nil
        }

        while (parser.nextEvent() != .objectEnd) {
            let fieldName = parser.currentName!
            parser.nextEvent()
            parseField(instance, fieldName, parser)
            parser.skipChildren()
        }
        return instance
    }

    override public func parseField(_ instance: PersistableLiteUser, _ fieldName: String, _ parser: JsonParser) {
        switch fieldName {
        default:
            break
        }
    }
}
