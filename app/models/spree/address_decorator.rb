Spree::Address.class_eval do
  belongs_to :user

  def self.required_fields
    validator = Spree::Address.validators.
      find{|v| v.kind_of?(ActiveModel::Validations::PresenceValidator)}
    validator ? validator.attributes : []
  end

  # override same as to ignore new user_id.  workaround for spec
  # failure for bad controller filter.
  # i don't like overriding same_as? to make controller filter work.
  # refactor this.
  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at', 'user_id') ==  other.attributes.except('id', 'updated_at', 'created_at', 'user_id')
  end

  # can modify an address if it's not been used in an order
  def editable?
    new_record? || (shipments.empty? && (Spree::Order.where("bill_address_id = ?", self.id).count + Spree::Order.where("bill_address_id = ?", self.id).count <= 1) && Spree::Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  # Checks if this address is used by any orders
  # If a current_order is passed in, it checks if it's used by any other orders
  def used?(current_order=nil)
    used_scope = Spree::Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id)
    used_scope = used_scope.where("id != ?", current_order.id) if current_order
    used_scope.count > 0
  end

  def can_be_deleted?
    shipments.empty? && ! used?
  end

  def to_s
    "#{firstname} #{lastname}: #{zipcode}, #{country}, #{state || state_name}, #{city}, #{address1} #{address2}"
  end

  def destroy_or_save
    if can_be_deleted?
      destroy
    else
      update_attribute(:deleted_at, Time.now)
    end
  end

end
