class ApplicationController < ActionController::Base
  before_action :common_content 

  def common_content
    @content = Management.first
  end
  
      
  
    def reset_session
        @_request.reset_session
      end
end
