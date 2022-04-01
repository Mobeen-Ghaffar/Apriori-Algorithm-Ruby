 require 'firebase'
 require "google/cloud/firestore"
 require 'barby'
 require 'barby/barcode/code_128'
 require 'Apriori'

base_uri = '' # Firebase Url
project_id='' # Firebase project ID
key_file="#{Rails.root}/key.json"


firestore = Google::Cloud::Firestore.new project_id:project_id, keyfile: key_file
# puts "Created Cloud Firestore client with given project ID."

users_ref = firestore.col "transaction" #reference to transactions
@total_sale_products
@support=0
puts "Apriori Algorithm"
@total_transactions=[]  # All transactions in 2d array
#puts @users_ref.inspect
@transactions = users_ref.get
@transactions.each do |t|
  # puts t.document_id
  @transaction=[] # products in each transaction
  @count=0
  sales_ref =firestore.col("transaction").doc(t.document_id).col("sale")
  @sale_products = sales_ref.get
  
  @sale_products.each do |s|
  #  puts s.data[:itemId]
    @count=@count+1
    @transaction.append(s.data[:itemId])
  end

  @total_transactions.append(@transaction) # append to 2d array..
  if @count>@support
    @support=@count 
  end
end
puts 'Total Transactions'
puts @total_transactions
@item_set = Apriori::ItemSet.new(@total_transactions)

# @support =4
@confidence = 0
puts @item_set.mine(@confidence,@support) # Function to find some frequent Item Set with confidence