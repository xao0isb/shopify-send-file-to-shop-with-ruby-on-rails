# frozen_string_literal: true

class ShopifyGraphql::Mutation::File::Create < ShopifyGraphql::Mutation::BaseMutation
  MUTATION = <<~MUTATION
    mutation fileCreate($files: [FileCreateInput!]!) {
      fileCreate(files: $files) {
        files {
          id
          fileStatus
          createdAt
          updatedAt

          fileErrors {
            code
            details
            message
          }
        }

        userErrors {
          field
          code
          message
        }
      }
    }
  MUTATION

  class << self
    def call(shop:, variables:)
      response = send_mutation(shop:, mutation: MUTATION, variables:)
      data = response.body["data"]
      result_data = data["fileCreate"]

      handle_errors!(result_data)

      data
    end

    private

    def handle_errors!(result_data)
      raise StandardError, result_data["userErrors"] if result_data["userErrors"].any?

      files = result_data["files"]
      files.each do |file|
        raise StandardError, file["fileErrors"] if file["fileErrors"].any?
      end
    end
  end
end
