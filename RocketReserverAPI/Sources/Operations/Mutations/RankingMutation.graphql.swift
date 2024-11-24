// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RankingMutation: GraphQLMutation {
  public static let operationName: String = "ranking"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ranking($roomId: String!) { post_ranking(room_id: $roomId) { __typename result } }"#
    ))

  public var roomId: String

  public init(roomId: String) {
    self.roomId = roomId
  }

  public var __variables: Variables? { ["roomId": roomId] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("post_ranking", Post_ranking?.self, arguments: ["room_id": .variable("roomId")]),
    ] }

    public var post_ranking: Post_ranking? { __data["post_ranking"] }

    /// Post_ranking
    ///
    /// Parent Type: `Result`
    public struct Post_ranking: RocketReserverAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Result }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("result", String.self),
      ] }

      public var result: String { __data["result"] }
    }
  }
}
