class CreateBuckets < ActiveRecord::Migration[6.0]
  def change
    create_table :buckets do |t|
      t.string :name
      t.string :policy_name
      t.string :bucket_user_name

      t.timestamps
    end
  end
end
