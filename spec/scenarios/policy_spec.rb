require 'spec_helper'
require 'sections/navigation'
require 'pages/login'
require 'pages/data_bags'
require 'pages/environments'

include Navigation

feature 'Policy', :type => :feature do
  given(:login_page) { Page::Login.new }
  given(:data_bags_page) { Page::DataBags.new }
  given(:environments_page) { Page::Environments.new }

  before(:each) do
    login_page.login FactoryGirl.build(:user, username: 'chef')
    Header.go_to_policy
  end

  scenario "data bags" do
    Policy.go_to_data_bags

    # create data bag
    bag = data_bags_page.create_data_bag
    expect(data_bags_page.find_data_bag(bag).text).to eq(bag.name)

    # create item
    data_bags_page.select_data_bag(bag)
    item = data_bags_page.create_item
    expect(data_bags_page.find_item(item).text).to eq(item.id)

    # edit item
    data_bags_page.select_item(item)
    data_bags_page.edit_selected_item( { 'id' => "#{item.id}", 'toast' => 'jam'} )
    expect(data_bags_page.item_data_content.text).to eq("id: #{item.id} toast: jam")

    # delete item
    data_bags_page.select_item(item)
    data_bags_page.delete_selected_item
    expect(data_bags_page.find_item(item).text).not_to match(item.id)

    # delete databag
    data_bags_page.select_data_bag(bag)
    data_bags_page.delete_selected_data_bag
    expect(data_bags_page.find_item(item).text).not_to match(bag.name)
  end

  scenario 'search data bag items' do
    Policy.go_to_data_bags

    # create databag
    bag = data_bags_page.create_data_bag

    # add 3 items - test1, test2, foo
    test1 = data_bags_page.create_item(FactoryGirl.build(:data_bag_item, id: 'test1'))
    test2 = data_bags_page.create_item(FactoryGirl.build(:data_bag_item, id: 'test2'))  
    foo = data_bags_page.create_item(FactoryGirl.build(:data_bag_item, id: 'foo'))

    # force solr index
    Solr.force_update

    # filter 'test' - should display two items
    expect(data_bags_page.search_item('test')).to match_array [test1.id, test2.id]

    # filter 'foo' should display 1 item
    expect(data_bags_page.search_item('foo')).to match_array [foo.id]

    # filter 'none' - should display 0 items
    expect(data_bags_page.search_item('none')).to match_array []

    # clean field - should display 3 items
    expect(data_bags_page.search_item('')).to match_array [test1.id, test2.id, foo.id]
  end

  scenario 'environments' do
    Policy.go_to_environments

    # 1.  Select to create an environment.
    # 2.  Give the environment a name and description.
    # 3.  Select 3-4 cookbooks as well as constraints.
    # 4.  Enter default and override attributes.
    # 5.  Save the environment.
    # 6.  Verify the Environment shows in the environments list.
    env = environments_page.create_environment

    # 7.  Verify Description, cookbook constraints are as set.
    deets = environments_page.get_selected_details
    expect(deets[:name]).to eq(env.name)
    expect(deets[:description]).to eq(env.description)

    # 8.  Verify Attributes as set.
    # later
  end
end
