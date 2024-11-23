// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PostRegistMutation: GraphQLMutation {
  public static let operationName: String = "PostRegist"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation PostRegist { post_register(input: { email: "", name: "", password: "" }) { __typename token } }"#
    ))

  public init() {}

  public struct Data: TestCore.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { TestCore.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("post_register", Post_register?.self, arguments: ["input": [
        "email": "",
        "name": "",
        "password": ""
      ]]),
    ] }

    public var post_register: Post_register? { __data["post_register"] }

    /// Post_register
    ///
    /// Parent Type: `Response`
    public struct Post_register: TestCore.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { TestCore.Objects.Response }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("token", String.self),
      ] }

      public var token: String { __data["token"] }
    }
  }
}
