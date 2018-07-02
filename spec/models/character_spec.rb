require 'rails_helper'

RSpec.describe Character, type: :model do
  describe "associations" do

    it "created by bragnikita" do
      character = create(:user_character)
      expect(character).to belong_to(:creator)
      expect(character.creator).to_not be_nil
      expect(character.creator.username).to eq "bragnikita"
    end

  end
end
