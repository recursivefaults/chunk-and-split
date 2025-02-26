
class VendResult 
  attr_reader :item, :change
  def initialize(item, change)
    @item = item
    @change = change
  end
end
