require 'faker'

class Org
  attr_accessor :name, :full_name
end

class User
  attr_accessor :name, :username, :password, :email, :company
end

class Role
  attr_accessor :name, :description
end

class DataBag
  attr_accessor :name
end

class DataBagItem
  attr_accessor :id, :attributes
end

class Environment
  attr_accessor :name, :description, :constraints, :default_attributes, :override_attributes
end


FactoryGirl.define do
  factory :org do
    name { "#{Faker::Internet.domain_word}#{Faker::Number.number(6)}" }
    full_name { "#{name}, #{Faker::Company.suffix}" }
  end

  factory :user do
    name Faker::Name.name
    username "#{Faker::Internet.user_name(nil, %w(_ -))}#{Faker::Number.number(6)}"
    password 'password'
    email Faker::Internet.email(username)
    company Faker::Company.name

    trait :username do
      Faker::Internet.user_name
    end
  end

  factory :role do
    sequence(:name) { |n| "role#{n}" }
    description Faker::Lorem.sentence
  end

  factory :data_bag do
    name "#{Faker::Lorem.word}-#{Faker::Number.number(6)}"
  end

  factory :data_bag_item do
    id "#{Faker::Lorem.word}-#{Faker::Number.number(6)}"
    attributes '{}'
  end

  factory :environment do
    name "#{Faker::Internet.domain_word}#{Faker::Number.number(6)}"
    description Faker::Lorem.sentence
    constraints nil # handle this later
    default_attributes '{}'
    override_attributes '{}'
  end
end
