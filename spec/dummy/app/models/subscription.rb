# frozen_string_literal: true

class Subscription < ApplicationRecord

  include ProviderKit::Provideable

  belongs_to :customer

end
