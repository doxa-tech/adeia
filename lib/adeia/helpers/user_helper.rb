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

      def add_to_group(name)
        group = Group.find_by_name(name)
        Adeia::GroupUser.create(group: group, user: self)
      end

      def permissions
        @permissions ||= Adeia::Permission.where(owner: groups << self)
      end

      def groups
        @groups ||= Adeia::Group.joins(:group_users).where(adeia_group_users: { user_id: self.id })
      end

    end
  end
end
