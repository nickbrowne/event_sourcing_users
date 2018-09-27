require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "MyText",
        :description => "MyText",
        :active => false,
        :visible => false
      ),
      User.create!(
        :name => "MyText",
        :description => "MyText",
        :active => false,
        :visible => false
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
