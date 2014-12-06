class UserDrop < Liquid::Drop
  def initialize(user)
    @user = user
  end

  delegate :name, :email, :address, to: :@user
end
