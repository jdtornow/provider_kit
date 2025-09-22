# frozen_string_literal: true

class Customer < ApplicationRecord

  has_many :subscriptions, dependent: :destroy

end
