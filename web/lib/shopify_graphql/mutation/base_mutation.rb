# frozen_string_literal: true

class ShopifyGraphql::Mutation::BaseMutation
  class << self
    def send_mutation(shop:, mutation:, variables:)
      shop.with_shopify_session do |session|
        client = ShopifyAPI::Clients::Graphql::Admin.new(session:)

        client.query(query: mutation, variables:)
      end
    end
  end
end
