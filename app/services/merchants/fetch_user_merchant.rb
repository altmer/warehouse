# frozen_string_literal: true

module Merchants
  class FetchUserMerchant
    include Callable

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      user = User.find_by(id: @user_id)
      return unless user

      user.merchant
    end
  end
end
