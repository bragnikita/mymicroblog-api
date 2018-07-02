# Snippets

## Simple
```ruby
require 'rails_helper'

RSpec.describe "context name" do
	describe 'sub-context' do
		let(:var) { new Date() }
		before { puts "Starting" }
		it 'should be today' do
			expect(var.day).to eq(Date.today().day)
		end
	ebd
end

```