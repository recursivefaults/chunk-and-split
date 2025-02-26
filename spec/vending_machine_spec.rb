require "vending_machine"

describe "Vending Machine" do
  let(:machine) { VendingMachine.new }

  describe "#add_money" do
    it "should accept money" do
      machine.add_money 1.15
      expect(machine.current_money).to equal(1.15)
    end

    it "should add money to the transaction when more is added" do
      machine.add_money 1.15
      machine.add_money 1
      expect(machine.current_money).to equal(2.15)
    end

    it "should not accept invalid numbers/nil for money" do
      expect {machine.add_money -1}.to raise_error InvalidMoney
      expect {machine.add_money nil}.to raise_error InvalidMoney
    end


    it "should return current transaction if it hasn't vended" do
      machine.add_money 1.15
      money = machine.return_money
      expect(money).to equal(1.15)
      expect(machine.current_money).to equal(0)
    end

  end

  it "should not vend an item if you don't have enough money" do
    snickers = InventoryItem.new(:Snickers, 1.00)
    machine.add_inventory_to_slot(snickers, 1, 10)
    item = machine.vend_item(1)
    expect(item).to be_nil
  end

  it "should not vend anything if it doesn't have that item" do
    expect {machine.vend_item(1)}.to raise_error NoItemAvailable
  end

  it "should vend when you have enough money and the item is there" do
    snickers = InventoryItem.new(:Snickers, 1.00)
    machine.add_inventory_to_slot(snickers, 1, 2)
    machine.add_money(2.00)
    item = machine.vend_item(1)
    expect(item.item.name).to equal(:Snickers)
  end
  
  it "should return change along with the item after a purchase" do
    snickers = InventoryItem.new(:Snickers, 1.00)
    machine.add_inventory_to_slot(snickers, 1, 2)
    machine.add_money(2.00)
    vend = machine.vend_item(1)
    expect(vend.item).not_to be_nil
    expect(vend.change).to equal(1.00)
  end
end
