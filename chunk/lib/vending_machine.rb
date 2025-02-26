require "inventory_item" 
require "errors"
require "vending_result"

class VendingMachine

  def initialize(slot_count = 10)  
    @transaction = 0
    @stored_money = 0
    slot_count = 1 if slot_count.nil? || slot_count < 0
    @slots = {}
    (0...slot_count).each do |i|
      @slots[i] = []
    end
  end

  public

  def vend_item(slot)
    raise InvalidSlot if slot < 0 || slot > @slots.count
    raise NoItemAvailable if @slots[slot].last.nil?
    price = @slots[slot].last.price
    raise NoItemAvailable if price.nil?
    return nil unless @transaction >= price
    item = @slots[slot].pop
    @stored_money += item.price
    change = @transaction - item.price
    @transaction = 0
    return VendResult.new(item, change)
  end

  def add_money(money)
    raise InvalidMoney if money.nil? || money < 0
    @transaction += money
  end

  def current_money
    @transaction
  end

  def return_money
    change = @transaction
    @transaction = 0
    change
  end

  def available_slots
    @slots.count
  end

  def stored_money
    @stored_money
  end

  def complete_transaction(price = 0)
    raise InvalidMoney if price.nil? || price < 0
  end


  def collect_money
    to_collect = @stored_money
    @stored_money = 0
    to_collect
  end


  def inventory_at(slot)
    raise InvalidSlot if slot < 0 || slot > @slots.count
    return @slots[slot]
  end

  def price_at(slot)
    raise InvalidSlot if slot < 0 || slot > @slots.count
    return nil if @slots[slot].last.nil?
    return @slots[slot].last.price
  end

  def add_inventory_to_slot(item, slot, quantity = 1)
    raise InvalidSlot if slot < 0 || slot > @slots.count
    (0...quantity).each do 
      @slots[slot].push item
    end
  end

end
