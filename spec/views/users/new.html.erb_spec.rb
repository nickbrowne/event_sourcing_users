require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :name => "MyText",
      :description => "MyText",
      :active => false,
      :visible => false
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "textarea[name=?]", "user[name]"

      assert_select "textarea[name=?]", "user[description]"

      assert_select "input[name=?]", "user[active]"

      assert_select "input[name=?]", "user[visible]"
    end
  end
end
