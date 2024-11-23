// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class Post_loginMutation: GraphQLMutation {
  public static let operationName: String = "Post_login"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Post_login($email: String!, $password: String!) { post_login(email: $email, password: $password) { __typename token } }"#
    ))

  public var email: String
  public var password: String

  public init(
    email: String,
    password: String
  ) {
    self.email = email
    self.password = password
  }

  public var __variables: Variables? { [
    "email": email,
    "password": password
  ] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("post_login", Post_login?.self, arguments: [
        "email": .variable("email"),
        "password": .variable("password")
      ]),
    ] }

    public var post_login: Post_login? { __data["post_login"] }

    /// Post_login
    ///
    /// Parent Type: `Response`
    public struct Post_login: RocketReserverAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Response }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("token", String.self),
      ] }

      public var token: String { __data["token"] }
    }
  }
}
