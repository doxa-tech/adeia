module Adeia
  module Helpers
    module UserHelper
      extend ActiveSupport::Concern

      module ClassMethods

        def human_name
          model_name.i18n_key
        end
      end

      included do
        extend ClassMethods

        has_many :permissions, class_name: "Adeia::Permission"
      end

    end
  end
end