// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class Post_resultMutation: GraphQLMutation {
  public static let operationName: String = "Post_result"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Post_result($roomId: String!, $score: Int!) { post_result(room_id: $roomId, score: $score) { __typename result } }"#
    ))

  public var roomId: String
  public var score: Int

  public init(
    roomId: String,
    score: Int
  ) {
    self.roomId = roomId
    self.score = score
  }

  public var __variables: Variables? { [
    "roomId": roomId,
    "score": score
  ] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("post_result", Post_result?.self, arguments: [
        "room_id": .variable("roomId"),
        "score": .variable("score")
      ]),
    ] }

    public var post_result: Post_result? { __data["post_result"] }

    /// Post_result
    ///
    /// Parent Type: `Result`
    public struct Post_result: RocketReserverAPI.SelectionSet {
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
