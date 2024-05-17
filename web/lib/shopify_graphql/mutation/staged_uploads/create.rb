# frozen_string_literal: true

class ShopifyGraphql::Mutation::StagedUploads::Create < ShopifyGraphql::Mutation::BaseMutation
  MUTATION = <<~MUTATION
    mutation stagedUploadsCreate($input: [StagedUploadInput!]!) {
      stagedUploadsCreate(input: $input) {
        stagedTargets {
          url
          resourceUrl
          parameters {
            name
            value
          }
        }

        userErrors {
          field
          message
        }
      }
    }
  MUTATION

  class << self
    def call(shop:, variables:)
      response = send_mutation(shop:, mutation: MUTATION, variables:)
      data = response.body["data"]
      result_data = data["stagedUploadsCreate"]

      raise StandardError, result_data["userErrors"] if result_data["userErrors"].any?

      data
    end
  end
end
