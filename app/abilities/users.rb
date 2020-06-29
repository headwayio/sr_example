Canard::Abilities.for(:user) do
  can [:manage, :api], User, id: user.id
  cannot [:destroy], User
  can :create, User

end
