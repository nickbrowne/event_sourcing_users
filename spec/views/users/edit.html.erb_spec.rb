require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :name => "MyText",
      :description => "MyText",
      :active => false,
      :visible => false
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "textarea[name=?]", "user[name]"

      assert_select "textarea[name=?]", "user[description]"

      assert_select "input[name=?]", "user[active]"

      assert_select "input[name=?]", "user[visible]"
    end
  end
end
