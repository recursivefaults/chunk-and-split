require "inventory"

require "cash_box"
require "errors"
require "vending_result"

class VendingMachine

  def initialize(slot_count = 10)  
    @inventory = Inventory.new(slot_count)
    @cashbox = CashBox.new
  end

  public

  def add_money money
    @cashbox.add_money money
  end

  def current_money
    @cashbox.current_transaction 
  end

  def return_money
    @cashbox.return_transaction
  end

  def add_inventory_to_slot(item, slot, quantity = 1)
    @inventory.add_items_to_slot(item, slot, quantity)
  end

  def vend_item(slot)
    item_exists?(slot)
    return nil unless should_vend?(slot)

    item = @inventory.dispense(slot)
    change = @cashbox.complete_transaction(item.price)

    return VendResult.new(item, change)
  end

  private

  def price_for_slot(slot)
    @inventory.price_at(slot)
  end

  def item_exists?(slot)
    price = price_for_slot(slot)
    raise NoItemAvailable if price.nil?
  end

  def should_vend?(slot)
    @cashbox.current_transaction >= price_for_slot(slot)
  end
end
