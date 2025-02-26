require "inventory"
describe "Inventory" do
  let(:inventory) { Inventory.new(10) }

  it "should have a set number of slots" do
    expect(inventory.slots).to equal(10)
  end

  it "should not create an inventory with 1 slot if invalid slot count is passed in" do
    inventory = Inventory.new(-1)
    expect(inventory.slots).to equal(1)

    inventory = Inventory.new()
    expect(inventory.slots).to equal(1)
  end

  it "should add items to a specified slot" do
    item = InventoryItem.new(:Doritos, 1.00)
    inventory.add_items_to_slot(item, 2, 5)
    expect(inventory.inventory_at(2).count).to equal(5)
    expect(inventory.inventory_at(1).count).to equal(0)
  end
  
  it "should add different items to the same slot" do
    item = InventoryItem.new(:Doritos, 1.00)
    second_item = InventoryItem.new(:Snickers, 2.5)
    inventory.add_items_to_slot(item, 2, 5 )
    inventory.add_items_to_slot(second_item, 2, 1)
    slot_inventory = inventory.inventory_at(2)
    expect(slot_inventory.count).to equal(6)
    expect(slot_inventory[4].name).to equal(item.name)
    expect(slot_inventory.last.name).to equal(second_item.name)
  end

  it "should say what the price is for the next item in the slot is" do
    item = InventoryItem.new(:Doritos, 1.00)
    inventory.add_items_to_slot(item, 2, 1)
    expect(inventory.price_at(2)).to equal(item.price)
  end

  it "should return nil for the price if there is no item at that slot" do
    expect(inventory.price_at(2)).to be_nil
  end

  it "should return an invalid slot error if you chose a slot that doesn't exist" do
    expect {inventory.price_at(11)}.to raise_error InvalidSlot
    expect {inventory.price_at(-1)}.to raise_error InvalidSlot
  end

  it "should dispense the requested item" do
    item = InventoryItem.new(:Doritos, 1.00)
    inventory.add_items_to_slot(item, 2, 2)
    dispensed_item = inventory.dispense(2)
    expect(dispensed_item.name).to equal(item.name)
    expect(inventory.inventory_at(2).count).to equal(1)
  end

  it "should dispense multiple items" do
    item = InventoryItem.new(:Doritos, 1.00)
    inventory.add_items_to_slot(item, 2, 2)
    dispensed_items = inventory.dispense(2, 2)
    expect(dispensed_items.count).to equal(2)
    expect(inventory.inventory_at(2).count).to equal(0)
  end

  it "should keep dispensing and price checks in sync" do 
    item = InventoryItem.new(:Doritos, 1.00)
    inventory.add_items_to_slot(item, 1, 1)
    item = InventoryItem.new(:Snickers, 2.00)
    inventory.add_items_to_slot(item, 1, 1)
    expect(inventory.price_at(1)).to eq(2)
    inventory.dispense(1)
    expect(inventory.price_at(1)).to eq(1)
  end

end
