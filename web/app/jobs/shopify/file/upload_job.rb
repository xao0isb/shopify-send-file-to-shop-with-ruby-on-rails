# frozen_string_literal: true

class Shopify::File::UploadJob < ApplicationJob
  queue_as :default

  def perform(file, shop:)
    staged_file = stage_file(file, shop:)

    upload_to_stage(file, stage_url: staged_file[:url], authentication_parameters: staged_file[:parameters])

    upload_from_stage_to_shop(resource_url: staged_file[:resourceUrl], shop:)
  end

  private

  def stage_file(file, shop:)
    variables = {
      input: [
        {
          filename: file.original_filename,
          mimeType: file.content_type,
          resource: "FILE",
          httpMethod: "POST"
        }
      ]
    }

    mutation_result = ShopifyGraphql::Mutation::StagedUploads::Create.call(shop:, variables:)
    staged_target = mutation_result["stagedUploadsCreate"]["stagedTargets"].first

    staged_target.transform_keys(&:to_sym)
  end

  def upload_to_stage(file, stage_url:, authentication_parameters:)
    form_data = [["file", file]]

    authentication_parameters.each do |parameter|
      form_data.prepend([parameter["name"], parameter["value"]])
    end

    FormData.new(action: stage_url, data: form_data).send
  end

  def upload_from_stage_to_shop(resource_url:, shop:)
    variables = {
      files: {
        originalSource: resource_url,
        contentType: "FILE"
      }
    }

    mutation_result = ShopifyGraphql::Mutation::File::Create.call(shop:, variables:)
    created_file = mutation_result["fileCreate"]["files"].first

    created_file.transform_keys(&:to_sym)
  end
end
