// Generated using Sourcery 0.6.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import PMJackson

extension UserEntities: JsonMappable {

}

public class UserEntitiesJsonMapper: JsonMapper<UserEntities> {

    public static let singleton = UserEntitiesJsonMapper()

    override public func parse(_ parser: JsonParser) -> UserEntities! {
        let instance = UserEntities()
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

    override public func parseField(_ instance: UserEntities, _ fieldName: String, _ parser: JsonParser) {
        switch fieldName {
        case "url":
            instance.url = EntitiesJsonMapper.singleton.parse(parser)
        case "description":
            instance.description = EntitiesJsonMapper.singleton.parse(parser)
        default:
            break
        }
    }
}
