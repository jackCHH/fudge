class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #required SessionsHelper to package functions together and incude them in multiple places
  include SessionsHelper
end
