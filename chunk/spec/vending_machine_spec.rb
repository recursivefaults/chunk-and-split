require "vending_machine"

describe "Vending Machine" do
  let(:machine) { VendingMachine.new }

  describe "#add_money" do
    it "should accept money" do
      machine.add_money 1.15
      expect(machine.current_money).to eq(1.15)
    end

    it "should add money to the transaction when more is added" do
      machine.add_money 1.15
      machine.add_money 1
      expect(machine.current_money).to eq(2.15)
    end

    it "should not accept invalid numbers/nil for money" do
      expect {machine.add_money -1}.to raise_error InvalidMoney
      expect {machine.add_money nil}.to raise_error InvalidMoney
    end
  end
  describe "#vend_item" do
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
      expect(item.item.name).to eq(:Snickers)
      expect(machine.inventory_at(1).count).to eq(1)
    end

    it "should return change along with the item after a purchase" do
      snickers = InventoryItem.new(:Snickers, 1.00)
      machine.add_inventory_to_slot(snickers, 1, 2)
      machine.add_money(2.00)
      vend = machine.vend_item(1)
      expect(vend.item).not_to be_nil
      expect(vend.change).to eq(1.00)
    end

    it "should keep a specific amount of money for a transaction" do
      snickers = InventoryItem.new(:Snickers, 0.75)
      machine.add_inventory_to_slot(snickers, 1, 2)
      machine.add_money(1.00)
      result = machine.vend_item(1)
      expect(result.change).to eq(0.25)
      expect(machine.stored_money).to eq(0.75)
    end
    
    it "should clear the current transaction after it completes a transaction" do
      snickers = InventoryItem.new(:Snickers, 0.75)
      machine.add_inventory_to_slot(snickers, 1, 2)
      machine.add_money(1.00)
      machine.vend_item(1)
      expect(machine.current_money).to eq(0.0)
    end

    it "should accumulate stored money across transactions" do
      snickers = InventoryItem.new(:Snickers, 0.75)
      machine.add_inventory_to_slot(snickers, 1, 2)
      machine.add_money(1.0)
      change = machine.vend_item(1)
      machine.add_money(1.0)
      change = machine.vend_item(1)
      expect(machine.stored_money).to eq(1.50)
    end
  end

  describe "#return_money" do
    it "should return the current transaction" do
      machine.add_money(1.0)
      change = machine.return_money
      expect(change).to eq(1.0)
      expect(machine.current_money).to eq(0)
    end
    it "should return nothing if there is no transaction" do
      change = machine.return_money
      expect(change).to eq(0)
      expect(machine.current_money).to eq(0)
    end
  end
  describe "#collect_money" do
    it "should give all the stored money" do
      snickers = InventoryItem.new(:Sickers, 0.75)
      machine.add_inventory_to_slot(snickers, 1, 2)
      machine.add_money(1.0)
      machine.vend_item(1)
      expect(machine.collect_money).to eq(0.75)
    end
    it "should not give what is in the current transaction" do
      snickers = InventoryItem.new(:Sickers, 0.75)
      machine.add_inventory_to_slot(snickers, 1, 2)
      machine.add_money(1.0)
      machine.vend_item(1)
      machine.add_money(1.0)
      expect(machine.collect_money).to eq(0.75)
      expect(machine.current_money).to eq(1.0)
    end
  end

  describe "Inventory" do
    it "should have a set number of slots" do
      expect(machine.available_slots).to eq(10)
    end

    it "should not create an inventory with 1 slot if invalid slot count is passed in" do
      machine = VendingMachine.new(-1)
      expect(machine.available_slots).to eq(1)

      machine = VendingMachine.new(nil)
      expect(machine.available_slots).to eq(1)
    end

    it "should add items to a specified slot" do
      item = InventoryItem.new(:Doritos, 1.00)
      machine.add_inventory_to_slot(item, 2, 5)
      expect(machine.inventory_at(2).count).to eq(5)
      expect(machine.inventory_at(1).count).to eq(0)
    end

    it "should add different items to the same slot" do
      item = InventoryItem.new(:Doritos, 1.00)
      second_item = InventoryItem.new(:Snickers, 2.5)
      machine.add_inventory_to_slot(item, 2, 5 )
      machine.add_inventory_to_slot(second_item, 2, 1)
      slot_inventory = machine.inventory_at(2)
      expect(slot_inventory.count).to eq(6)
      expect(slot_inventory[4].name).to eq(item.name)
      expect(slot_inventory.last.name).to eq(second_item.name)
    end

    it "should say what the price is for the next item in the slot is" do
      item = InventoryItem.new(:Doritos, 1.00)
      machine.add_inventory_to_slot(item, 2, 1)
      expect(machine.price_at(2)).to eq(item.price)
    end

    it "should return nil for the price if there is no item at that slot" do
      expect(machine.price_at(2)).to be_nil
    end

    it "should return an invalid slot error if you chose a slot that doesn't exist" do
      expect {machine.price_at(11)}.to raise_error InvalidSlot
      expect {machine.price_at(-1)}.to raise_error InvalidSlot
    end


    it "should keep dispensing and price checks in sync" do 
      item = InventoryItem.new(:Doritos, 1.00)
      machine.add_inventory_to_slot(item, 1, 1)
      item = InventoryItem.new(:Snickers, 2.00)
      machine.add_inventory_to_slot(item, 1, 1)
      machine.add_money(2.00)
      expect(machine.price_at(1)).to eq(2)
      machine.vend_item(1)
      expect(machine.price_at(1)).to eq(1)
    end
  end
end
