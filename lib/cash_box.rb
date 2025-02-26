require "errors"

class CashBox

  def initialize
    clear_transaction
    @stored_money = 0
  end

  def add_money(money)
    is_money_valid?(money)
    @transaction += money
  end

  def return_transaction
    complete_transaction(0)
  end

  def complete_transaction(price = 0)
    is_money_valid?(price)
    @stored_money += price
    get_change(price)
  end

  def stored_money
    @stored_money
  end

  def collect_money
    to_collect = @stored_money
    @stored_money = 0
    to_collect
  end

  def current_transaction
    @transaction
  end

  private

  def get_change(price)
    change = @transaction - price
    clear_transaction
    change
  end

  def is_money_valid?(money)
    raise InvalidMoney if money.nil? || money < 0
  end

  def clear_transaction
    @transaction = 0
  end

end
