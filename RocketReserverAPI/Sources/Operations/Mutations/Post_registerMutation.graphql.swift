// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class Post_registerMutation: GraphQLMutation {
  public static let operationName: String = "Post_register"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Post_register($email: String!, $name: String!, $password: String!) { post_register(email: $email, name: $name, password: $password) { __typename token } }"#
    ))

  public var email: String
  public var name: String
  public var password: String

  public init(
    email: String,
    name: String,
    password: String
  ) {
    self.email = email
    self.name = name
    self.password = password
  }

  public var __variables: Variables? { [
    "email": email,
    "name": name,
    "password": password
  ] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { RocketReserverAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("post_register", Post_register?.self, arguments: [
        "email": .variable("email"),
        "name": .variable("name"),
        "password": .variable("password")
      ]),
    ] }

    public var post_register: Post_register? { __data["post_register"] }

    /// Post_register
    ///
    /// Parent Type: `Response`
    public struct Post_register: RocketReserverAPI.SelectionSet {
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
