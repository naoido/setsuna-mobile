// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class Post_matchingMutation: GraphQLMutation {
  public static let operationName: String = "Post_matching"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Post_matching($isLeave: Boolean!) { post_matching(is_leave: $isLeave) { __typename user_count room_id is_matched } }"#
    ))

  public var isLeave: Bool

  public init(isLeave: Bool) {
    self.isLeave = isLeave
  }

  public var __variables: Variables? { ["isLeave": isLeave] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("post_matching", Post_matching?.self, arguments: ["is_leave": .variable("isLeave")]),
    ] }

    public var post_matching: Post_matching? { __data["post_matching"] }

    /// Post_matching
    ///
    /// Parent Type: `MatchStatus`
    public struct Post_matching: RocketReserverAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.MatchStatus }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("user_count", Int?.self),
        .field("room_id", String?.self),
        .field("is_matched", Bool?.self),
      ] }

      public var user_count: Int? { __data["user_count"] }
      public var room_id: String? { __data["room_id"] }
      public var is_matched: Bool? { __data["is_matched"] }
    }
  }
}
