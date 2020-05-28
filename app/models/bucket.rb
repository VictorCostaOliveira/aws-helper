class Bucket < ApplicationRecord
  validates_presence_of :name, :policy_name, :bucket_user_name
  validates_uniqueness_of :name, :policy_name, :bucket_user_name
end
