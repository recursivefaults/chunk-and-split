require "cash_box"

describe "Cash Box" do
  let(:cashbox) { CashBox.new }
  describe "#add_money" do
    it "should accept money" do
      cashbox.add_money(1.0)
      expect(cashbox.current_transaction).to equal(1.0)
    end
    it "should accumulate money" do
      cashbox.add_money(1.0)
      cashbox.add_money(0.50)
      expect(cashbox.current_transaction).to equal(1.5)
    end
    it "should not accept negative money" do
      expect { cashbox.add_money(-1.0) }.to raise_error InvalidMoney
    end
    it "should not accept nil money" do
      expect { cashbox.add_money(nil) }.to raise_error InvalidMoney
    end
  end
  describe "#return_transaction" do
    it "should return the current transaction" do
      cashbox.add_money(1.0)
      change = cashbox.return_transaction
      expect(change).to eq(1.0)
      expect(cashbox.current_transaction).to eq(0)
    end
    it "should return nothing if there is no transaction" do
      change = cashbox.return_transaction
      expect(change).to eq(0)
      expect(cashbox.current_transaction).to eq(0)
    end
  end
  describe "#collect_money" do
    it "should give all the stored money" do
      cashbox.add_money(1.0)
      cashbox.complete_transaction(0.75)
      expect(cashbox.collect_money).to eq(0.75)
    end
    it "should not give what is in the current transaction" do
      cashbox.add_money(1.0)
      cashbox.complete_transaction(0.75)
      cashbox.add_money(1.0)
      expect(cashbox.collect_money).to eq(0.75)
      expect(cashbox.current_transaction).to eq(1.0)
    end
  end
  describe "#complete_transaction" do
    it "should keep a specific amount of money for a transaction" do
      cashbox.add_money(1.0)
      change = cashbox.complete_transaction(0.75)
      expect(change).to eq(0.25)
      expect(cashbox.stored_money).to eq(0.75)
    end

    it "should not complete a transaction for a negative price" do
      cashbox.add_money(1.0)
      expect { cashbox.complete_transaction(-1) }.to raise_error InvalidMoney
    end

    it "should return all the money if the price is nil" do
      cashbox.add_money(1.0)
      expect {cashbox.complete_transaction(nil)}.to raise_error InvalidMoney
    end
    
    it "should clear the current transaction after it completes a transaction" do
      cashbox.add_money(1.0)
      cashbox.complete_transaction(0.75)
      expect(cashbox.current_transaction).to eq(0.0)
    end

    it "should accumulate stored money across transactions" do
      cashbox.add_money(1.0)
      change = cashbox.complete_transaction(0.75)
      cashbox.add_money(1.0)
      change = cashbox.complete_transaction(0.50)
      expect(cashbox.stored_money).to eq(1.25)
    end
  end

end
