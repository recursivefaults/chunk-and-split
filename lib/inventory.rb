require "inventory_item"
require "errors"

class Inventory
  def initialize(slots=1)
    initialize_slots(slots)
  end

  def slots
    @slots.count
  end

  def add_items_to_slot(item, slot, quantity = 1)
    is_slot_valid?(slot)
    (0...quantity).each do 
      @slots[slot].push item
    end
  end

  def inventory_at(slot)
    is_slot_valid?(slot)
    return @slots[slot]
  end

  def price_at(slot)
    is_slot_valid?(slot)
    return nil if item_at(slot).nil?
    return item_at(slot).price
  end

  def dispense(slot, quantity = 1)
    is_slot_valid?(slot)
    dispensed_items = collect_dispensed_items(slot, quantity)
    return dispensed_items.first if quantity == 1
    return dispensed_items
  end

  def clear_inventory
    initialize_slots(slots)
  end

  private
  def collect_dispensed_items(slot, quantity)
    dispensed_items = []
    (0...quantity).each do 
      dispensed_items << @slots[slot].pop
    end
    dispensed_items
  end

  def item_at(slot)
    @slots[slot].last
  end

  def initialize_slots(slot_count)
    slot_count = 1 if slot_count.nil? || slot_count < 0
    @slots = {}
    (0...slot_count).each do |i|
      @slots[i] = []
    end
  end

  def is_slot_valid?(slot)
    raise InvalidSlot if slot < 0 || slot > self.slots
  end

end

