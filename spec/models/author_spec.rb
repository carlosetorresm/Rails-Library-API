require 'rails_helper'

RSpec.describe Author, type: :model do
  it 'Create Author' do
    FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell', age: 120)
  end
end
