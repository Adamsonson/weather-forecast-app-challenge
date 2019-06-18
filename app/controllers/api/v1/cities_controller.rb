class Api::V1::CitiesController < Api::V1::BaseController
  def index
    @cities = policy_scope(City)
  end
end
