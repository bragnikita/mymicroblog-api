# == Schema Information
#
# Table name: users
#
#  id       :bigint(8)        not null, primary key
#  username :string(255)      not null
#  password :string(255)      not null
#  email    :string(255)
#  admin    :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe User, type: :model do

  describe "all users validations" do

    it "is valid with minimum attributes" do
      expect(build(:user_with_mail)).to be_valid
    end

    it "is not valid without username" do
      expect(build(:user_with_mail, username: "")).to be_invalid
    end

    it "must not allow username duplication" do
      create(:user_with_mail, username: "bragnikita")
      expect(build(:user_with_mail, username: "bragnikita")).to be_invalid
    end
    it "must require for password" do
      expect(build(:user_with_mail, password: nil )).to be_invalid
      expect(build(:user_with_mail, password: "" )).to be_invalid
    end

  end

  describe "admin user validation" do
    it "must save admin user" do
      expect(create(:admin)).to be_valid
    end
    it "must require email" do
      expect(build(:admin, email: nil)).to be_invalid
    end
  end

  describe "associations" do
    subject { create(:user, :with_characters) }
    it "must fetch user's characters" do
      expect(subject).to have_many(:characters)
      expect(subject.characters).to have_exactly(3).items
    end
    it "must fetch user's scripts" do
      expect()
    end
    it "must fetch user's character lists"
  end


end
