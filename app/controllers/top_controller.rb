class TopController < ApplicationController
  def show
    allow
    @concerts = Concert.order(:created_at).reverse_order
  end
end
