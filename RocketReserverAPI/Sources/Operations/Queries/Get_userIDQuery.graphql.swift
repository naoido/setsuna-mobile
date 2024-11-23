// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class Get_userIDQuery: GraphQLQuery {
  public static let operationName: String = "Get_userID"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Get_userID { get_userID { __typename user_id } }"#
    ))

  public init() {}

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("get_userID", Get_userID.self),
    ] }

    public var get_userID: Get_userID { __data["get_userID"] }

    /// Get_userID
    ///
    /// Parent Type: `UserID`
    public struct Get_userID: RocketReserverAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.UserID }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("user_id", String.self),
      ] }

      public var user_id: String { __data["user_id"] }
    }
  }
}
