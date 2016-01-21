# coding: utf-8
module ReservationForm
  def self.included(base)
    base.class_eval {
      include ActiveAttr::Model
      include ActiveAttr::TypecastedAttributes
      include ActiveModel::Associations

      def record_save
        if self.valid?
          record = Reservation.new()
          return record.from_form(self) ? record : false
        else
          errors[:base] = '購入できませんでした,もう一度やり直してください'
        end
      end

      def [](attr)
        self.send(attr)
      end

      def []=(attr, value)
        self.send("#{attr}=", value)
      end

      attr_accessor :user_id
      belongs_to :user
      attr_accessor :grade_id
      belongs_to :grade
      attribute :payment_method, :type => Integer

      validate :validate_user_is_buyer
      def validate_user_is_buyer
        unless self.user.buyer?
          errors[:user_id] = 'ログインユーザーが不正です'
        end
      end

      validate :validate_event_sell_ok?
      def validate_event_sell_ok?
        unless self.grade.event.sell_ok?
          errors[:grade_id] = '販売できません'
        end
      end

      validates :payment_method, numericality: { only_integer: true }, inclusion: { in: Reservation.payment_methods.values }
    }
  end
end
