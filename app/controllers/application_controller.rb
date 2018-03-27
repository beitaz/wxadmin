class ApplicationController < ActionController::API
  include TokenAuthenticatable
  include AdminAuthorizable
end
