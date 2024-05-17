# frozen_string_literal: true

class FilesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # fix later
    # shop = Shop.find_by(shopify_domain: current_shopify_domain)
    shop = Shop.last

    Shopify::File::UploadJob.perform_now(params[:file], shop: Shop.last)
  end
end
