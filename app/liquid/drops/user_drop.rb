class UserDrop < Liquid::Drop
  def initialize(user)
    @user = user
  end

  delegate :name, :email, to: :@user
end
