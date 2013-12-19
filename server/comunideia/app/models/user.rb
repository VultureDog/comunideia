class User < Couchbase::Model

  attribute :cpf
  attribute :name
  attribute :email
  attribute :password

  def self.find_or_create_from_auth_hash(hash)
    user = User.find_by_id(hash[:cpf])
    unless user
      user = User.create!(:cpf => hash[:info][:cpf],
                          :name => hash[:info][:name],
                          :email => hash[:info][:email],
                          :password => hash[:info][:password])
    end
    user
  end
end